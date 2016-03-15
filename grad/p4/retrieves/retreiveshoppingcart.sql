/********************************
 *
 *  Retrieve Shopping Cart 
 *
 ********************************/
 --Find an Order
CREATE OR REPLACE FUNCTION retrieve_shoppingcart(v_customerID INTEGER)
RETURNS TABLE(v_sid INTEGER,
  v_customerID INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shopping_Cart.sid,
           Shopping_Cart.customerID
	FROM Shopping_Cart
	WHERE customerID=v_customerID;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_shoppingcart(1);

------------------------------------------------------------------------

 --Find all product suppliers
CREATE OR REPLACE FUNCTION retrieve_shoppingcart_all()
RETURNS TABLE(v_sid INTEGER,
  v_customerID INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Shopping_Cart.sid,
           Shopping_Cart.customerID
    FROM Shopping_Cart;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_shoppingcart_all();