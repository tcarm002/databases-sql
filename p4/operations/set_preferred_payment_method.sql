/*******************************************
 *
 *  Set preferred payment method function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION set_preferred_payment_method(v_customerId INTEGER,
  v_cc_id INTEGER )
RETURNS TEXT AS 
$func$
DECLARE
-- RETURNS message indicating successful change
  msg TEXT := 'Default payment method could not be changed.';
  updated BOOL = False;
  v_oldCC INTEGER;
BEGIN
  --check if this is actually the customers credit card
  IF NOT EXISTS(SELECT * 
            FROM Credit_Cards
            WHERE customerId = v_customerId
            AND cc_id = v_cc_id)
  THEN
          msg := 'This credit card ID does not belong to this customer.';
          RETURN msg;
  END IF;

  --Checks first if this is already the preferred payment method.
  IF EXISTS(SELECT * 
            FROM Credit_Cards
            WHERE customerId = v_customerId
            AND cc_id = v_cc_id
            AND defaultCC = '1') 
  THEN
            msg := 'This is already the preferred payment method. No action taken.' ;
            RETURN msg;
  END IF;

  --Check if customer already has a preferred payment method, if so, unset.
  IF EXISTS(SELECT *
            FROM Credit_Cards 
            WHERE customerId = v_customerId 
            AND defaultCC = '1')
  THEN
            SELECT cc_id INTO v_oldCC
            FROM Credit_Cards 
            WHERE customerId = v_customerId 
            AND defaultCC = '1';
            
            PERFORM update_creditcard(v_oldCC,NULL,NULL,NULL,NULL,'0');
            RAISE NOTICE 'Old default payment method % unset', v_oldCC; 
  END IF;

  --Then set given ccid as new preferred payment method.
  SELECT update_creditcard(v_cc_id,NULL,NULL,NULL,NULL,'1') INTO updated;
    IF updated THEN
      msg := 'New preferred payment method set.';
    END IF;
RETURN msg;
END;
$func$ LANGUAGE plpgsql;

