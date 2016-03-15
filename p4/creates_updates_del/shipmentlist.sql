/**********************************
 *
 *  Shipment List functions
 *
 ***********************************/
--Create a new customer address link
CREATE OR REPLACE FUNCTION create_shipmentlist(v_qty INTEGER,
  v_ship_id INTEGER,
  v_carrier_id INTEGER,
  v_itemListId INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS shipListId
DECLARE v_shipListId INTEGER;
BEGIN
  INSERT INTO Shipment_List (qty,ship_id,carrier_id,itemListId)
    SELECT v_qty,v_ship_id,v_carrier_id,v_itemListId
  WHERE NOT EXISTS(
    SELECT 1
    FROM Shipment_List
    WHERE 		   qty = v_qty
    	AND   ship_id  = v_ship_id
    	AND carrier_id = v_carrier_id
    	AND itemListId = v_itemListId
  )
  RETURNING shipListId INTO v_shipListId;
RETURN v_shipListId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipment_List;
SELECT create_shipmentlist(45,1,1,1);
SELECT * FROM Shipment_List;

--------------------------------------------------------------------------------------------------------------

--Updates shipment list information. Must specify the shipListId.
CREATE OR REPLACE FUNCTION update_shipmentlist(v_shipListId INTEGER,
  v_qty INTEGER DEFAULT NULL,
  v_ship_id INTEGER DEFAULT NULL,
  v_carrier_id INTEGER DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_shipListId IS NULL THEN
    RAISE WARNING 'Please supply shipListId.';
  ELSE
    UPDATE Shipment_List
	SET  		 qty  = COALESCE(v_qty , qty),
		     ship_id  = COALESCE(v_ship_id , ship_id),
		  carrier_id  = COALESCE(v_carrier_id , carrier_id),
		  itemListId  = COALESCE(v_itemListId , itemListId)
    WHERE  shipListId = v_shipListId;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipment_List;
SELECT update_shipmentlist(1,5001);

--------------------------------------------------------------------------------------------------------------

--Delete shipment list information, requires shipListId or shipment list info;
CREATE OR REPLACE FUNCTION delete_shipmentlist(v_shipListId INTEGER DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_ship_id INTEGER DEFAULT NULL,
  v_carrier_id INTEGER DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_shipListId INTEGER := v_shipListId;
BEGIN
  --Populates itemListId if user is supplying only item list info. 
  IF v_shipListId is NULL THEN
    SELECT shipListId INTO v_shipListId
    FROM Shipment_List
     WHERE 		   qty = v_qty
    	AND   ship_id  = v_ship_id
    	AND carrier_id = v_carrier_id
    	AND itemListId = v_itemListId;
  END IF;


    DELETE FROM Shipment_List 
          WHERE shipListId = v_shipListId ;
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shipment_List;
SELECT delete_shipmentlist(8);
SELECT * FROM Shipment_List;
