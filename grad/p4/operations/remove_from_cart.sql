/*******************************************
 *
 *  Remove from cart function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION remove_from_cart(v_pid INTEGER,
v_customerId INTEGER)
RETURNS text AS 
$func$
DECLARE
  success BOOLEAN;
  msg TEXT := 'FAILURE';
  v_sid INTEGER;
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
    --Remove item from cart
    SELECT delete_cartitem(NULL,NULL,v_pid,v_sid) INTO success;
    IF success
    THEN
        msg := 'Item successfully removed from cart.';
    ELSE
        msg :='Item could not be removed from cart.';
    END IF;
  ELSE
    msg := 'Item not in cart, cannot remove!';
  END IF;
  RETURN msg;
END;
$func$ LANGUAGE plpgsql;


