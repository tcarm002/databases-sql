/**************************
 *
 *  Shopping Cart functions
 *
 **************************/
--Create a new shopping cart
CREATE OR REPLACE FUNCTION create_shoppingcart(v_customerID INTEGER)
RETURNS INTEGER AS
$func$
-- RETURNS sid
DECLARE v_sid INTEGER;
BEGIN
  INSERT INTO Shopping_Cart (customerID)
    SELECT v_customerID
  WHERE NOT EXISTS(
    SELECT 1
    FROM Shopping_Cart
    WHERE customerID  = v_customerID
      
  )
  RETURNING sid INTO v_sid;
RETURN v_sid;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shopping_Cart;
SELECT create_shoppingcart();
SELECT * FROM Shopping_Cart;

--must test, need to fix customer add

--------------------------------------------------------------------------------------------------------------

--Updates shopping cart information. Must specify the sid.
CREATE OR REPLACE FUNCTION update_shoppingcart(v_sid INTEGER,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_sid IS NULL THEN
    RAISE WARNING 'Please supply sid.';
  ELSE
    UPDATE Shopping_Cart
    SET customerID  = COALESCE(v_customerID , customerID)
    WHERE       sid = v_sid;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shopping_Cart;
SELECT update_shoppingcart(5,6);


--------------------------------------------------------------------------------------------------------------

--Delete shopping cart, requires sid or customerId info;
CREATE OR REPLACE FUNCTION delete_shoppingcart(v_sid INTEGER,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_sid INTEGER := v_sid;
BEGIN
  --Populates sid if user is supplying only customerId. 
  IF v_sid is NULL THEN
    SELECT sid INTO v_sid
    FROM Shopping_Cart
    WHERE   customerID     = v_customerID;
  END IF;

    DELETE FROM Shopping_Cart 
          WHERE sid = v_sid ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Shopping_Cart;
SELECT delete_shoppingcart(5);
SELECT * FROM Shopping_Cart;
