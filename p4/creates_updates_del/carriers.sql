/**************************
 *
 *  Carriers functions
 *
 **************************/
--Create a new carrier
CREATE OR REPLACE FUNCTION create_carrier(v_hazardous BOOLEAN,
  v_name VARCHAR(45),
  v_ship_type VARCHAR(45))
RETURNS INTEGER AS
$func$
-- RETURNS carrier_id
DECLARE v_carrier_id INTEGER;
BEGIN
  INSERT INTO Carriers (hazardous,name,ship_type)
       SELECT v_hazardous,v_name,v_ship_type
  WHERE NOT EXISTS(
    SELECT 1
    FROM Carriers
    WHERE hazardous = v_hazardous
      AND name = v_name
      AND ship_type = v_ship_type
  )
  RETURNING carrier_id INTO v_carrier_id;
RETURN v_carrier_id;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Carriers;
SELECT create_carrier('0','Phillip Delivers','all');
SELECT * FROM Carriers;

--------------------------------------------------------------------------------------------------------------

--Updates carrier information. Must specify the carrier_id.
CREATE OR REPLACE FUNCTION update_carrier(v_carrier_id INTEGER,
	v_hazardous BOOLEAN DEFAULT NULL,
	v_name VARCHAR(45) DEFAULT NULL,
	v_ship_type VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_carrier_id IS NULL THEN
    RAISE WARNING 'Please supply carrier_id.';
  ELSE
    UPDATE Carriers
    SET     hazardous  = COALESCE(v_hazardous, hazardous),
            name  	   = COALESCE(v_name, name),
            ship_type  = COALESCE(v_ship_type, ship_type)
    WHERE carrier_id = v_carrier_id;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Carriers;
SELECT update_carrier(1,'1');
SELECT * FROM Carriers;


--------------------------------------------------------------------------------------------------------------

--Delete carrier, requires carrier_id or carrier info;
CREATE OR REPLACE FUNCTION delete_carrier(v_carrier_id INTEGER DEFAULT NULL,
	v_hazardous BOOLEAN DEFAULT NULL,
	v_name VARCHAR(45) DEFAULT NULL,
	v_ship_type VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_carrier_id INTEGER := v_carrier_id;
BEGIN
  --Populates returnListId if user is supplying only item info. 
  IF v_carrier_id is NULL THEN
    SELECT carrier_id INTO v_carrier_id
    FROM Carriers
    WHERE   hazardous = v_hazardous
      AND   	 name = v_name
      AND 	ship_type = v_ship_type;
  END IF;

  	If EXISTS(SELECT * 
  		FROM Shipment_List 
  		WHERE carrier_id = v_carrier_id) 
  	THEN
  		RAISE WARNING 'Cannot delete carrier since he is linked to an existing shipment.';
	ELSE
    	DELETE FROM Carriers 
          WHERE carrier_id = v_carrier_id ;
	END IF;
	  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Carriers;
SELECT delete_carrier(7);
SELECT * FROM Carriers;