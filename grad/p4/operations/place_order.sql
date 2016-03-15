/*******************************************
 *
 *  Place Order function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION place_order(v_customerID INTEGER)
RETURNS NUMERIC AS 
$func$
DECLARE
  success BOOLEAN;
  msg TEXT := 'FAILURE';
  temp NUMERIC:= 0.0;
  row_data Cart_Items%ROWTYPE;
  rdata Product_Supplier%ROWTYPE;

  v_sid INTEGER;
  v_store_credit_bal NUMERIC;
  v_cc_id INTEGER;
  v_date DATE;
  treu_b BOOLEAN := '1';
  v_ret INTEGER;
  v_supplier_id INTEGER;
  orderID INTEGER;
  total NUMERIC;
  v_discount NUMERIC;
BEGIN
  --Find shopping cart
  EXECUTE 'SELECT sid 
  FROM Shopping_Cart
  WHERE customerID = $1'
  USING v_customerID
  INTO v_sid;

  --Check if  that cart is not empty
  IF EXISTS(SELECT * 
            FROM Cart_Items
            WHERE sid = v_sid)
  THEN
      --Get order date
      EXECUTE 'select current_date'
      INTO v_date;

      
        --Create a new order
        SELECT create_order(v_date,v_customerID) INTO orderID;
        
       
        FOR row_data IN SELECT * FROM Cart_Items WHERE sid = v_sid 
        LOOP
            SELECT MIN(Product_Supplier.price -(Product_Supplier.price * Suppliers.discount / 100.0)), Product_Supplier.supplier_id  
            INTO total, v_supplier_id
            FROM Product_Supplier, Suppliers
            WHERE row_data.pid = Product_Supplier.pid
            AND Product_Supplier.supplier_id = Suppliers.supplier_id
            GROUP BY Product_Supplier.supplier_id ;

            --Place items in to order item list
            PERFORM create_itemlist('0',row_data.qty,'0',total,orderID,v_supplier_id);
             --Remove items from cart once order is complete
            PERFORM remove_from_cart(row_data.pid,v_customerID);
        END LOOP;
  END IF;
  RETURN v_ret;
END;
$func$ LANGUAGE plpgsql;

