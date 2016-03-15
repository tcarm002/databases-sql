/********************************
 *
 *  Retrieve Addresses functions
 *
 ********************************/
 --Find an address entry
CREATE OR REPLACE FUNCTION retrieve_address(v_aid INTEGER)
RETURNS TABLE(v_aid INTEGER,
    v_street VARCHAR(45),
	v_city VARCHAR(45),
    v_country VARCHAR(45),
    v_zip VARCHAR(45),
    v_state VARCHAR(45),
    v_apt VARCHAR(45) ) AS
$func$
-- RETURNS Address of given aid
BEGIN
   	RETURN QUERY
    SELECT Addresses.aid,
           Addresses.street,
    	   Addresses.city,
    	   Addresses.country,
    	   Addresses.zip,
    	   Addresses.state,
    	   Addresses.apt 
	FROM Addresses
	WHERE aid=v_aid;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_address(1);

------------------------------------------------------------------------

 --Find an address entry
CREATE OR REPLACE FUNCTION retrieve_address_all()
RETURNS TABLE(v_aid INTEGER,
    v_street VARCHAR(45),
	v_city VARCHAR(45),
    v_country VARCHAR(45),
    v_zip VARCHAR(45),
    v_state VARCHAR(45),
    v_apt VARCHAR(45) ) AS
$func$
-- RETURNS Address of given aid
BEGIN
   	RETURN QUERY
    SELECT Addresses.aid,
           Addresses.street,
    	   Addresses.city,
    	   Addresses.country,
    	   Addresses.zip,
    	   Addresses.state,
    	   Addresses.apt 
	FROM Addresses;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_address_all();