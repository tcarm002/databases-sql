/********************************
 *
 *  Retrieve Product Suppliers 
 *
 ********************************/
 --Find a Product supplier
CREATE OR REPLACE FUNCTION retrieve_productsupplier(v_supplierId INTEGER)
RETURNS TABLE(v_supplierId INTEGER,
  v_price NUMERIC,
  v_supplier_id INTEGER,
  v_pid INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Product_Supplier.supplierId,
           Product_Supplier.price,
    	   Product_Supplier.supplier_id,
    	   Product_Supplier.pid
	FROM Product_Supplier
	WHERE supplierId=v_supplierId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_productsupplier(1);

------------------------------------------------------------------------

 --Find all product suppliers
CREATE OR REPLACE FUNCTION retrieve_productsupplier_all()
RETURNS TABLE(v_supplierId INTEGER,
  v_price NUMERIC,
  v_supplier_id INTEGER,
  v_pid INTEGER  ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Product_Supplier.supplierId,
           Product_Supplier.price,
           Product_Supplier.supplier_id,
           Product_Supplier.pid
    FROM Product_Supplier;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_productsupplier_all();