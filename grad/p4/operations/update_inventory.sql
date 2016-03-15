/*******************************************
 *
 *  Update Inventory function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION update_inventory(v_pid INTEGER, 
  v_sID INTEGER,
  productCount INTEGER)
RETURNS TEXT AS 
$func$
DECLARE 
  msg TEXT := 'Inventory could not be updated.';
  v_supplierId INTEGER;
  v_qty INTEGER;
  updated BOOLEAN;
BEGIN
  
  --Finds pk of item
  SELECT supplierId,qty
  INTO v_supplierId,v_qty
  FROM Product_Supplier
  WHERE Product_Supplier.pid = v_pid
  AND Product_Supplier.supplier_id = v_sID;
  
  raise notice 'supp id %, qty %',v_supplierId,v_qty;
  v_qty := v_qty + productCount;

  --update inventory, depending on sign of productCount
  SELECT update_productsupplier(v_supplierId,NULL,v_qty,NULL,NULL) INTO updated;

  IF updated
  THEN
    msg := 'Inventory was succesfully updated.';
  END IF;
  --return message to confirm
  RETURN msg;
END;
$func$ LANGUAGE plpgsql;