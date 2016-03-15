/*******************************************
 *
 *  Retrieve Customer Addressess functions
 *
 *******************************************/
 --Find customer address linking information
CREATE OR REPLACE FUNCTION retrieve_customeraddress(v_customerAddressId INTEGER)
RETURNS TABLE(v_customerAddressId INTEGER,
  v_preferred BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER) AS
$func$
-- RETURNS supplier info of given supplierId
BEGIN
   	RETURN QUERY
    SELECT Customer_Addresses.customerAddressId,
           Customer_Addresses.preferred,
      	   Customer_Addresses.aid,
      	   Customer_Addresses.customerID
  	FROM Customer_Addresses
  	WHERE customerAddressId=v_customerAddressId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_customeraddress(3);

------------------------------------------------------------------------

 --Find all address linking info in the database
CREATE OR REPLACE FUNCTION retrieve_customeraddress_all()
RETURNS TABLE(v_customerAddressId INTEGER,
  v_preferred BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Customer_Addresses.customerAddressId,
           Customer_Addresses.preferred,
           Customer_Addresses.aid,
           Customer_Addresses.customerID
    FROM Customer_Addresses;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_customeraddress_all();