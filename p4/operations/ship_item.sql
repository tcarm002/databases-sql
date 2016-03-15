/*******************************************
 *
 *  Ship Item function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION ship_item(v_oid INTEGER,v_pid INTEGER)
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
      RAISE WARNING 'Shipment already exists. Exiting.';
      RETURN '0';
  END IF;


  --charge the customer
  SELECT charge_customer(v_oid,v_pid,v_customerID) INTO v_supplierID;

  IF v_supplierID = 0
  THEN
    RETURN '0';
  END IF;
  
  --Compute the new qty
  --Check the order item list for qty
  SELECT qty, itemListId INTO v_qty, v_itemListId
  FROM Item_List
  WHERE oid = v_oid
  AND supplierId = v_supplierID;

  SELECT qty INTO oldQty
  FROM Product_Supplier
  WHERE supplierId = v_supplierID;

  --adjust the inventory
  PERFORM update_productsupplier(v_supplierId,NULL,oldQty-v_qty);


  




  

  --create a shipment as a single transaction and mark as partial
  SELECT create_shipment('1',v_date,v_aid,v_oid,v_customerID) INTO v_ship_id;

  --add item into shipment list
  PERFORM create_shipmentlist(v_qty,v_ship_id,1,v_itemListId);
RETURN FOUND;
END;
$func$ LANGUAGE plpgsql;