/*******************************************
 *
 *  Add to cart function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION add_to_cart(v_pid INTEGER,
v_qty INTEGER,
v_customerId INTEGER)
RETURNS text AS 
$func$
DECLARE
  v_supplierId INTEGER;
  v_sid INTEGER;
  -- RETURNS whether or not add to cart was successful
  msg TEXT := 'Item could not be added to cart.';
BEGIN
  --Find shopping cart
  EXECUTE 'SELECT sid
          FROM Shopping_Cart
          WHERE customerId = $1'
          USING v_customerId
          INTO v_sid;
  
  --Check if item is in cart
  IF EXISTS(SELECT * 
            FROM Cart_Items
            WHERE pid = v_pid
            AND sid = v_sid)
  THEN
    msg :=  'Item already in cart. Item was not added.';
    RETURN msg;
  ELSE
    --Place into cart
    PERFORM create_cartitem(v_qty,v_pid,v_sid);
    msg := 'Item added to cart';
  END IF;
  RETURN msg;
END;
$func$ LANGUAGE plpgsql;


