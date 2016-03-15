/********************************
 *
 *  Retrieve Cart Items
 *
 ********************************/
 --Find Cart items
CREATE OR REPLACE FUNCTION retrieve_cartitems(v_cartID INTEGER)
RETURNS TABLE(v_cartID INTEGER,
  v_qty INTEGER ,
  v_pid INTEGER ,
  v_sid INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Cart_Items.cartID,
           Cart_Items.qty,
           Cart_Items.pid,
           Cart_Items.sid
  	FROM Cart_Items
  	WHERE cartID=v_cartID;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_cartitems(1);

------------------------------------------------------------------------

 --Find all product suppliers
CREATE OR REPLACE FUNCTION retrieve_cartitems_all()
RETURNS TABLE(v_cartID INTEGER,
  v_qty INTEGER ,
  v_pid INTEGER ,
  v_sid INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Cart_Items.cartID,
           Cart_Items.qty,
           Cart_Items.pid,
           Cart_Items.sid
    FROM Cart_Items;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_cartitems_all();