/*******************************************
 *
 *  Charge Customer function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION charge_customer(v_oid INTEGER,v_pid INTEGER,v_customerID INTEGER)
RETURNS INTEGER AS 
--RETURNS the supplier id of the supplier the item was bought from
$func$
DECLARE
  total NUMERIC := 0.0;
  v_store_credit_bal NUMERIC;
  v_date DATE;
  v_itemListId INTEGER;
  v_cc_id INTEGER;
  v_qty INTEGER;
  v_supplierID INTEGER; --return
BEGIN
      --Find item in item list
      SELECT Product_Supplier.supplier_Id, Item_List.itemListId, Item_List.price, Item_List.qty 
      INTO v_supplierID , v_itemListId, total, v_qty
      FROM Item_List, Product_Supplier
      WHERE Item_List.oid = v_oid
      
      AND Item_List.supplierId = Product_Supplier.supplier_Id
      AND Product_Supplier.pid = v_pid;
      

      --Check how much store credit the user has
      EXECUTE 'SELECT store_credit_bal 
      FROM Customer
      WHERE customerID =$1'
      USING v_customerID
      INTO v_store_credit_bal;

      --Find out how much to charge to store credit/ credit card
      IF total >= v_store_credit_bal
      THEN
        --Deduct store credit from total
        total := total - v_store_credit_bal;
      ELSE
        total := 0;
        v_store_credit_bal := v_store_credit_bal - total;
      END IF;

      --update changes in customer table, updating the customer funds
      PERFORM update_customer(v_customerID,NULL,NULL,NULL,NULL,NULL,NULL,v_store_credit_bal);

      --make sure user has set a default payment method
      IF NOT EXISTS(SELECT *
                    FROM Credit_Cards
                    WHERE customerID = v_customerID
                    AND DefaultCC = '1'
                    )
      THEN
        RAISE NOTICE 'Customer must set a default payment method to charge this order!';
        RETURN 0;
      ELSE
                    --finds users preferred payment method
                    SELECT cc_id INTO v_cc_id
                    FROM Credit_Cards
                    WHERE customerID = v_customerID
                    AND DefaultCC = '1';
      END IF;

      
      --Note todays date
      EXECUTE 'select current_date'
      INTO v_date;

      RAISE WARNING 'v_oid %,v_date %,total %,v_store_credit_bal %,v_customerID %,v_qty %,v_supplierID %,v_cc_id %'
      ,v_oid,v_date,total,v_store_credit_bal,v_customerID,v_qty,v_supplierID,v_cc_id;

       --charge customer, ensures the customer is not charged more than once.
      INSERT INTO Charges (oid,date,cc_amt,store_credit_bal,customerID,qty,supplierId,cc_id)
      SELECT v_oid,v_date,total,v_store_credit_bal,v_customerID,v_qty,v_supplierID,v_cc_id
      WHERE NOT EXISTS(SELECT 1
                        FROM Charges
                        WHERE                oid = v_oid
                          AND               date = v_date
                          AND             cc_amt = total
                          AND   store_credit_bal = v_store_credit_bal
                          AND         customerID = v_customerID
                          AND                qty = v_qty
                          AND         supplierId = v_supplierID
                          AND              cc_id = v_cc_id
                      );   

  RETURN v_supplierID;
END;
$func$ LANGUAGE plpgsql;

