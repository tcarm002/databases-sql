/*******************************************
 *
 *  Ship Order function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION ship_order(v_oid INTEGER)
RETURNS BOOLEAN AS 
$func$
DECLARE
  v_customerID INTEGER;
  v_supplierID INTEGER;
  v_qty INTEGER;
  oldQty INTEGER;
  v_date DATE;
  v_aid INTEGER;
  v_ship_id INTEGER;
  v_itemListId INTEGER;
  v_pid INTEGER;
  row_data Item_List%ROWTYPE;
BEGIN
  --Find customer ID
  SELECT customerID INTO v_customerID
  FROM Orders
  WHERE oid = v_oid;

  --Find ship date
  EXECUTE 'select current_date'
  INTO v_date;


  --make sure user has set a default shipping address
  IF NOT EXISTS(SELECT *
                FROM Customer_Addresses
                WHERE customerID = v_customerID
                AND preferred = '1'
                )
  THEN
    RAISE NOTICE 'Customer must set a default shipping address to charge this order!';
    RETURN 0;
  ELSE
          --Find aid of customer
          SELECT aid INTO v_aid
          FROM Customer_Addresses
          WHERE customerID = v_customerID
          AND preferred = '1';
  END IF;


  IF EXISTS (SELECT *
            FROM Shipments
            WHERE    ship_date = v_date
            AND          aid = v_aid
            AND          oid = v_oid
            AND   customerID = v_customerID)
  THEN
      RAISE WARNING 'Shipment already exists. Was this a partial order? Exiting.';
      RETURN '0';
  END IF;

  --create a shipment as a single transaction and mark as complete
  SELECT create_shipment('0',v_date,v_aid,v_oid,v_customerID) INTO v_ship_id;

  --LOOP through order and charge each item
  FOR row_data IN SELECT * FROM Item_List WHERE oid = v_oid
  LOOP
    --find out pid
    SELECT pid INTO v_pid
    FROM Product_Supplier, Item_List
    WHERE Product_Supplier.supplier_id = Item_List.supplierId
    AND Item_List.supplierId = row_data.supplierId;

    --charge the customer
    SELECT charge_customer(v_oid,v_pid,v_customerID) INTO v_supplierID;
       
    If v_supplierID = 0
    THEN
      RAISE WARNING 'Order could not be shipped. Check messages.';
      PERFORM delete_shipment(v_ship_id);
      RETURN '0';
    END IF;

    --add item into shipment list
    PERFORM create_shipmentlist(row_data.qty,v_ship_id,1,row_data.itemListId);


       RAISE WARNING 'v_oid %,v_pid %,v_customerID %, v_supplierID %'
       , v_oid,v_pid,v_customerID, v_supplierID;

    --Qty to remove from inventory
    v_qty := row_data.qty;

    SELECT qty INTO oldQty
    FROM Product_Supplier
    WHERE supplierId = v_supplierID;

    --adjust the inventory
    PERFORM update_productsupplier(v_supplierId,NULL,oldQty-v_qty);
  END LOOP;


  
RETURN FOUND;
END;
$func$ LANGUAGE plpgsql;