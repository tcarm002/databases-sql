/**************************
 *
 *  Shipments functions
 *
 **************************/
--Create a new shipment
CREATE OR REPLACE FUNCTION create_shipment(v_partial BOOLEAN,
  v_ship_date DATE,
  v_aid INTEGER,
  v_oid INTEGER ,
  v_customerID INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS ship_id
DECLARE v_ship_id INTEGER;
BEGIN
  INSERT INTO Shipments (partial,ship_date,aid,oid,customerID)
       SELECT v_partial,v_ship_date,v_aid,v_oid,v_customerID
  WHERE NOT EXISTS(
    SELECT 1
    FROM Shipments
    WHERE    partial = v_partial
      AND  ship_date = v_ship_date
      AND        aid = v_aid
      AND        oid = v_oid
      AND customerID = v_customerID
  )
  RETURNING ship_id INTO v_ship_id;
RETURN v_ship_id;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipments;
SELECT create_shipment('0','2019-1-1',1,1,1);
SELECT * FROM Shipments;

--------------------------------------------------------------------------------------------------------------

--Updates shipment information. Must specify the ship_id.
CREATE OR REPLACE FUNCTION update_shipment(v_ship_id INTEGER,
  v_partial BOOLEAN DEFAULT NULL,
  v_ship_date DATE DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_customerID INTEGER  DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_ship_id IS NULL THEN
    RAISE WARNING 'Please supply ship_id.';
  ELSE
    UPDATE Shipments
    SET     partial  	= COALESCE(v_partial, partial),
            ship_date  	= COALESCE(v_ship_date, ship_date),
            aid  		= COALESCE(v_aid, aid),
            oid  		= COALESCE(v_oid, oid),
            customerID  = COALESCE(v_customerID, customerID)
    WHERE ship_id = v_ship_id;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipments;
SELECT update_shipment(7,NULL,'2013-4-4',NULL,NULL,NULL);
SELECT * FROM Shipments;


--------------------------------------------------------------------------------------------------------------

--Delete shipment, requires ship_id or shipment info;
CREATE OR REPLACE FUNCTION delete_shipment(v_ship_id INTEGER DEFAULT NULL,
  v_partial BOOLEAN DEFAULT NULL,
  v_ship_date DATE DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_customerID INTEGER  DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_ship_id INTEGER := v_ship_id;
BEGIN
  --Populates ship_id if user is supplying only shipment info. 
  IF v_ship_id is NULL THEN
    SELECT ship_id INTO v_ship_id
    FROM Shipments
    WHERE    partial = v_partial
      AND  ship_date = v_ship_date
      AND 	     aid = v_aid
      AND		 oid = v_oid
      AND customerID = v_customerID;
  END IF;


   --must delete items from shipment list first
  	DELETE FROM shipment_List
  	WHERE ship_id = v_ship_id;

  	--Then delete shipment
    DELETE FROM Shipments 
          WHERE ship_id = v_ship_id ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipments;
SELECT delete_shipment(7);
SELECT * FROM Shipments;