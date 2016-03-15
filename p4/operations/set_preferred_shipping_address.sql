/*******************************************
 *
 *  Set preferred shipping address function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION set_preferred_shipping_address(v_customerId INTEGER,
  v_aid INTEGER )
RETURNS TEXT AS 
$func$
DECLARE
-- RETURNS message indicating successful change
  msg TEXT := 'Preferred shipping address could not be set.';
  updated BOOL = False;
  v_customerAddressId INTEGER;
BEGIN
  --Checks first if this is already the preferred shipping address.
  IF EXISTS(SELECT * 
            FROM Customer_Addresses
            WHERE customerId = v_customerId
            AND aid = v_aid
            AND preferred = '1') 
  THEN
            msg := 'This is already the preferred address. No action taken.' ;
            RETURN msg;
  END IF;

  --Check if customer already has a preferred address, if so, unset.
  IF EXISTS(SELECT *
            FROM Customer_Addresses 
            WHERE customerId = v_customerId 
            AND preferred = '1')
  THEN
            SELECT customerAddressId INTO v_customerAddressId
            FROM Customer_Addresses 
            WHERE customerId = v_customerId 
            AND preferred = '1';

            PERFORM update_customeraddress(v_customerAddressId,'0');
            RAISE NOTICE 'Old preferred shipping address % unset', v_customerAddressId; 
  END IF;

  --find customerAddressId of address to be set as preferred
  SELECT customerAddressId INTO v_customerAddressId
  FROM Customer_Addresses
  WHERE customerId = v_customerId
  AND aid = v_aid;

  --Then set given address as new preferred address.
  SELECT update_customeraddress(v_customerAddressId,'1') INTO updated;
    IF updated THEN
      msg := 'New preferred shipping address set.';
    END IF;
RETURN msg;
END;
$func$ LANGUAGE plpgsql;


