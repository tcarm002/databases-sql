/********************************
 *
 *  Retrieve Carriers
 *
 ********************************/
 --Find Shipment
CREATE OR REPLACE FUNCTION retrieve_carriers(v_carrier_id INTEGER)
RETURNS TABLE(v_carrier_id INTEGER,
  v_hazardous BOOLEAN,
  v_name VARCHAR(45),
  v_ship_type VARCHAR(45)  ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Carriers.carrier_id,
           Carriers.hazardous,
           Carriers.name,
           Carriers.ship_type
  	FROM Carriers
  	WHERE carrier_id=v_carrier_id;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_carriers(1);

------------------------------------------------------------------------

 --Find all carriers
CREATE OR REPLACE FUNCTION retrieve_carriers_all()
RETURNS TABLE(v_carrier_id INTEGER,
  v_hazardous BOOLEAN,
  v_name VARCHAR(45),
  v_ship_type VARCHAR(45) ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Carriers.carrier_id,
           Carriers.hazardous,
           Carriers.name,
           Carriers.ship_type
    FROM Carriers;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_carriers_all();