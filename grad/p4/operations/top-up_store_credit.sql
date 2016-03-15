/*******************************************
 *
 *  Top Up Store Credit function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION top_up_store_credit(v_customerID INTEGER)
RETURNS NUMERIC AS 
$func$
DECLARE
v_store_credit_bal NUMERIC;
BEGIN
	IF NOT EXISTS(SELECT *
				FROM Customer
				  WHERE customerID = v_customerID )
	THEN
		RAISE WARNING 'Customer does not exist.';
	ELSE
	  SELECT Customer.store_credit_bal INTO v_store_credit_bal
	  FROM Customer 
	  WHERE customerID = v_customerID;
    END IF;
RETURN v_store_credit_bal;
END;
$func$ LANGUAGE plpgsql;