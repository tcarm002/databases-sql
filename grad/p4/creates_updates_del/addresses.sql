/**************************
 *
 *	Addresses functions
 *
 **************************/
--Create a new address entry
CREATE OR REPLACE FUNCTION create_address(v_street VARCHAR(45),
  v_city VARCHAR(45),
  v_country VARCHAR(45),
  v_zip VARCHAR(45),
  v_state VARCHAR(45) DEFAULT NULL,
  v_apt VARCHAR(45) DEFAULT NULL)
RETURNS INTEGER AS
$func$
-- RETURNS AID
DECLARE v_aid INTEGER;
BEGIN
	INSERT INTO Addresses (street,city,state,country,zip,apt)
	SELECT v_street,v_city,v_state,v_country,v_zip,v_apt
	WHERE NOT EXISTS(
		SELECT 1
		FROM Addresses
		WHERE street=v_street 
		  AND city=v_city 
		  AND state=v_state
		  AND country=v_country
		  AND zip=v_zip
		  AND apt=v_apt
	)
	RETURNING aid INTO v_aid;
RETURN v_aid;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Addresses;
SELECT create_address('5000 Plum Lane', 'Austin', 'USA','34512', 'TX', 'b');
SELECT * FROM Addresses;

--------------------------------------------------------------------------------------------------------------

--Updates address information. Must specify the aid.
CREATE OR REPLACE FUNCTION update_address(v_aid INTEGER,
  v_street VARCHAR(45) DEFAULT NULL,
  v_city VARCHAR(45) DEFAULT NULL,
  v_country VARCHAR(45) DEFAULT NULL,
  v_zip VARCHAR(45) DEFAULT NULL,
  v_state VARCHAR(45) DEFAULT NULL,
  v_apt VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
	IF v_aid IS NULL THEN
		RAISE WARNING 'Please supply aid.';
	ELSE
		UPDATE Addresses
	    SET 
	    	street  = COALESCE(v_street, street),
	       	city    = COALESCE(v_city, city),
	       	country = COALESCE(v_country, country),
	       	zip     = COALESCE(v_zip, zip),
	       	state   = COALESCE(v_state, state),
	       	apt     = COALESCE(v_apt, apt)
	 	WHERE 	 aid = v_aid;
 	END IF;

 	RETURN FOUND; --Indicates whether address was modified
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Addresses;
SELECT update_address(13,'900 South River drive');
SELECT * FROM Addresses;
SELECT update_address(5, 	NULL,  	NULL,  	NULL,  	NULL,  	NULL, '');
SELECT * FROM Addresses;

--------------------------------------------------------------------------------------------------------------

--Delete Address, requires aid or complete address;
CREATE OR REPLACE FUNCTION delete_address(v_aid INTEGER DEFAULT NULL,
	v_street VARCHAR(45) DEFAULT NULL,
  	v_city VARCHAR(45) DEFAULT NULL,
  	v_country VARCHAR(45) DEFAULT NULL,
  	v_zip VARCHAR(45) DEFAULT NULL,
  	v_state VARCHAR(45) DEFAULT NULL,
  	v_apt VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
	v_aid INTEGER:= v_aid;
BEGIN
	--check first if address is used in any credit card or shipment records,
	--if so, do not delete, only delete reference in linking table
	IF v_aid is NULL THEN
		SELECT aid INTO v_aid 
		FROM Addresses
		WHERE 	street  = v_street
	    	AND city    = v_city
	    	AND country = v_country
	    	AND zip     = v_zip
	    	AND state   = v_state
	    	AND apt     = v_apt;
	END IF;

	IF EXISTS(
		SELECT aid FROM Credit_Cards WHERE aid = v_aid) 
	OR
		EXISTS(SELECT aid FROM Shipments WHERE aid = v_aid)
	OR
		EXISTS(SELECT aid FROM Suppliers WHERE aid = v_aid)
	THEN
		RAISE WARNING 'Address will remain in database since it is related
			to a shipment, supplier or credit card record. However, linking info will
			be deleted.';
	ELSE
		DELETE FROM Addresses 
	    WHERE        aid	= v_aid 
	        OR (	
	        	    street  = v_street
	        	AND city    = v_city
	        	AND country = v_country
	        	AND zip     = v_zip
	        	AND state   = v_state
	        	AND apt     = v_apt
	    	);
	END IF;

	DELETE FROM Customer_Addresses
	WHERE aid = v_aid ;
	RETURN FOUND; --Indicates whether supplier was deleted.
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Addresses;
SELECT delete_address(1);
SELECT * FROM Addresses;
