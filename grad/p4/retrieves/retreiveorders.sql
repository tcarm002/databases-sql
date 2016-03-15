/********************************
 *
 *  Retrieve Orders 
 *
 ********************************/
 --Find an Order
CREATE OR REPLACE FUNCTION retrieve_order(v_oid INTEGER)
RETURNS TABLE(v_oid INTEGER,
  v_cc_amt NUMERIC,
  v_date DATE,
  v_customerID INTEGER,
  v_cc_id INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Orders.oid,
           Orders.cc_amt,
    	   Orders.date,
    	   Orders.customerID,
           Orders.cc_id
	FROM Orders
	WHERE oid=v_oid;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_order(1);

------------------------------------------------------------------------

 --Find all product suppliers
CREATE OR REPLACE FUNCTION retrieve_order_all()
RETURNS TABLE(v_oid INTEGER,
  v_cc_amt NUMERIC,
  v_date DATE,
  v_customerID INTEGER,
  v_cc_id INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Orders.oid,
           Orders.cc_amt,
           Orders.date,
           Orders.customerID,
           Orders.cc_id
    FROM Orders;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_order_all();