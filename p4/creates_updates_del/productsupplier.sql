/**************************
 *
 *  Product Suppliers functions
 *
 **************************/
--Create a new product supplier entry
CREATE OR REPLACE FUNCTION create_productsupplier(v_price NUMERIC ,
  v_qty INTEGER,
  v_supplier_id INTEGER ,
  v_pid INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS product supplier id
DECLARE v_supplierId INTEGER;
BEGIN
  INSERT INTO Product_Supplier (price, qty, supplier_id, pid)
    SELECT v_price, v_qty, v_supplier_id, v_pid  
  WHERE NOT EXISTS(
    SELECT 1
    FROM Product_Supplier
    WHERE price       = v_price
      AND supplier_id = v_supplier_id
      AND pid         = v_pid 
  )
  RETURNING supplierId INTO v_supplierId;
RETURN v_supplierId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Product_Supplier;
SELECT create_productsupplier(25.00,1000000,1,3);
SELECT * FROM Product_Supplier;

--------------------------------------------------------------------------------------------------------------

--Updates product supplier information. Must specify the supplierId.
CREATE OR REPLACE FUNCTION update_productsupplier(v_supplierId INTEGER,
  v_price NUMERIC DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_supplier_id INTEGER DEFAULT NULL,
  v_pid INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_supplierId IS NULL THEN
    RAISE WARNING 'Please supply supplier_id.';
  ELSE
    UPDATE Product_Supplier
      SET 
          price             = COALESCE(v_price , price),
          qty               = COALESCE(v_qty , qty),
          supplier_id       = COALESCE(v_supplier_id, supplier_id),
          pid               = COALESCE(v_pid, pid)
    WHERE        supplierId = v_supplierId;
    RETURN FOUND; 

  END IF;

  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Product_Supplier;
SELECT update_productsupplier(3,0.67);


--------------------------------------------------------------------------------------------------------------

--Delete product supplier, requires supplierId or complete info;
CREATE OR REPLACE FUNCTION delete_productsupplier(v_supplierId INTEGER DEFAULT NULL,
  v_price NUMERIC DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_supplier_id INTEGER DEFAULT NULL,
  v_pid INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_supplierId INTEGER := v_supplierId;
BEGIN
  --check first if product is used in any ... records,
  --if so, do not delete, only delete reference in linking table
  IF v_supplierId is NULL THEN
    SELECT supplierId INTO v_supplierId 
    FROM Product_Supplier
    WHERE   price          = v_price
        AND qty            = v_qty
        AND supplier_id    = v_supplier_id
        AND pid            = v_pid;
  END IF;

    DELETE FROM Product_Supplier 
            WHERE supplierId = v_supplierId ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Product_Supplier;
SELECT delete_productsupplier(6);
SELECT * FROM Products;
