/*******************************************
 *
 *  Get availability function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION get_availability(v_pid INTEGER)
RETURNS INTEGER AS 
$func$
DECLARE
  -- RETURNS number of products available
  num INTEGER;
  num2 INTEGER;
BEGIN
  --count number of products in the product supplier table
  SELECT SUM(qty) INTO num
  FROM Product_Supplier
  WHERE pid = v_pid;

  --Take into account unshipped orders
  SELECT SUM(Item_List.qty) INTO num2
  FROM item_list,Product_Supplier
  WHERE Product_Supplier.pid = v_pid
  AND item_list.supplierid = Product_Supplier.supplier_id;

  RETURN num - num2;
END;
$func$ LANGUAGE plpgsql;