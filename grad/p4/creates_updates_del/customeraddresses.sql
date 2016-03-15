/**********************************
 *
 *  Customer Addresses functions
 *
 ***********************************/
--Create a new customer address link
CREATE OR REPLACE FUNCTION create_customeraddress(v_preferred BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS customerAddressId
DECLARE v_customerAddressId INTEGER;
BEGIN
  IF v_preferred AND EXISTS(SELECT customerAddressId 
                            FROM Customer_Addresses
                            WHERE customerID = v_customerID
                            AND preferred = v_preferred)
                 AND NOT EXISTS(SELECT 1
                                FROM Customer_Addresses
                                WHERE       aid = v_aid
                                AND customerID  = v_customerID)
THEN
    RAISE WARNING 'Customer already has set a preferred shipping address.
      Changing % into new preferred shipping address.', v_aid;
      EXECUTE        'SELECT customerAddressId 
                            FROM Customer_Addresses
                            WHERE customerID = $1
                            AND preferred = $2'
                            USING v_customerID, v_preferred
                            INTO v_customerAddressId;
      SELECT update_customeraddress(v_customerAddressId, '0');
  END IF;
  INSERT INTO Customer_Addresses (preferred,aid,customerID)
    SELECT v_preferred,v_aid,v_customerID
  WHERE NOT EXISTS(
    SELECT 1
    FROM Customer_Addresses
    WHERE   preferred = v_preferred 
      AND         aid = v_aid
      AND customerID  = v_customerID
  )
  RETURNING customerAddressId INTO v_customerAddressId;
RETURN v_customerAddressId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Customer_Addresses;
SELECT create_customeraddress();
SELECT * FROM Customer_Addresses;

--------------------------------------------------------------------------------------------------------------

--Updates customer address information. Must specify the customerAddressId.
CREATE OR REPLACE FUNCTION update_customeraddress(v_customerAddressId INTEGER,
  v_preferred BOOLEAN DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_customerAddressId IS NULL THEN
    RAISE WARNING 'Please supply customerAddressId.';
  ELSE

    UPDATE Customer_Addresses
    SET 		 preferred = COALESCE(v_preferred, preferred),  
                aid  	 = COALESCE(v_aid , aid),
    			 customerID  = COALESCE(v_customerID , customerID)
    WHERE  customerAddressId = v_customerAddressId;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Customer_Addresses;
SELECT update_customeraddress(6, NULL,2,NULL);

--------------------------------------------------------------------------------------------------------------

--Delete customer address information, requires customerAddressId or customer address info;
CREATE OR REPLACE FUNCTION delete_customeraddress(v_customerAddressId INTEGER DEFAULT NULL,
  v_preferred BOOLEAN DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_customerAddressId INTEGER := v_customerAddressId;
BEGIN
  --Populates sid if user is supplying only customerId. 
  IF v_customerAddressId is NULL THEN
    SELECT customerAddressId INTO v_customerAddressId
    FROM Customer_Addresses
    WHERE   	aid    = v_aid
    	AND customerID = v_customerID;
  END IF;

    DELETE FROM Customer_Addresses 
          WHERE customerAddressId = v_customerAddressId ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Customer_Addresses;
SELECT delete_customeraddress(5);
SELECT * FROM Customer_Addresses;
