/********************************
 *
 *  Retrieve Shipments
 *
 ********************************/
 --Find Shipment
CREATE OR REPLACE FUNCTION retrieve_shipments(v_ship_id INTEGER)
RETURNS TABLE(v_ship_id INTEGER,
  v_partial BOOLEAN,
  v_ship_date DATE,
  v_aid INTEGER,
  v_oid INTEGER,
  v_customerID INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shipments.ship_id,
           Shipments.partial,
           Shipments.ship_date,
           Shipments.aid,
           Shipments.oid,
           Shipments.customerID
  	FROM Shipments
  	WHERE ship_id=v_ship_id;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_shipments(1);

------------------------------------------------------------------------

 --Find all shipments
CREATE OR REPLACE FUNCTION retrieve_shipments_all()
RETURNS TABLE(v_ship_id INTEGER,
  v_partial BOOLEAN,
  v_ship_date DATE,
  v_aid INTEGER,
  v_oid INTEGER,
  v_customerID INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shipments.ship_id,
           Shipments.partial,
           Shipments.ship_date,
           Shipments.aid,
           Shipments.oid,
           Shipments.customerID
    FROM Shipments;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_shipments_all();