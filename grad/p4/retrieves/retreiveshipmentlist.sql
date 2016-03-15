
-- -----------------------------------------------------
-- Table Shipment_List
-- -----------------------------------------------------
DROP TABLE IF EXISTS Shipment_List CASCADE;
DROP SEQUENCE IF EXISTS shipListId_seq CASCADE;
CREATE SEQUENCE shipListId_seq;

CREATE TABLE  Shipment_List (
  shipListId INTEGER PRIMARY KEY DEFAULT  nextval('shipListId_seq'),
  qty INTEGER NOT NULL CHECK (qty >0),
  ship_id INTEGER NOT NULL REFERENCES Shipments (ship_id),
  carrier_id INTEGER NOT NULL REFERENCES Carriers (carrier_id),
  itemListId INTEGER NOT NULL REFERENCES Item_List (itemListId)
);

/*******************************************
 *
 *  Retrieve Item List functions
 *
 *******************************************/
 --Find item list linking information
CREATE OR REPLACE FUNCTION retrieve_shipmentlist(v_shipListId INTEGER)
RETURNS TABLE(v_shipListId INTEGER,
  v_qty INTEGER,
  v_ship_id INTEGER,
  v_carrier_id INTEGER,
  v_itemListId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shipment_List.shipListId,
      	   Shipment_List.qty,
           Shipment_List.ship_id,
           Shipment_List.carrier_id,
           Shipment_List.itemListId
  	FROM Shipment_List
  	WHERE shipListId = v_shipListId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_shipmentlist(3);

------------------------------------------------------------------------

 --Find all address linking info in the database
CREATE OR REPLACE FUNCTION retrieve_shipmentlist_all()
RETURNS TABLE(v_shipListId INTEGER,
  v_qty INTEGER,
  v_ship_id INTEGER,
  v_carrier_id INTEGER,
  v_itemListId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shipment_List.shipListId,
           Shipment_List.qty,
           Shipment_List.ship_id,
           Shipment_List.carrier_id,
           Shipment_List.itemListId
    FROM Shipment_List;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_shipmentlist_all();