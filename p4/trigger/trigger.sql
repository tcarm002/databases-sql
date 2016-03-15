CREATE OR REPLACE FUNCTION restock()
	RETURNS trigger AS
	$$
	DECLARE
		 total INTEGER = 0;
		 threshold INTEGER;
		 v_name VARCHAR(45);
		 v_co_name VARCHAR(45);
		 row_data Product_Supplier%ROWTYPE;
		 v_supplier_id INTEGER;
		 v_price NUMERIC;
	BEGIN
		RAISE NOTICE 'Trigger executed.';
		--for each row of product suppliers table where new.pid =
		--add up qty of all 
		FOR row_data IN SELECT * FROM Product_Supplier WHERE pid = NEW.pid 
      	LOOP
      		--total qty of all items with same pid
            total := row_data.qty + total;
            RAISE NOTICE 'TOTAL %.',total;
      	END LOOP;

      	SELECT low_inv_thresh INTO threshold
      	FROM Products
      	WHERE pid = NEW.pid;

		IF total <= threshold THEN
			RAISE NOTICE 'Threshold reached.';

			--find out who is the best supplier to restock the product
			  SELECT Products.name, MIN(Product_Supplier.price -(Product_Supplier.price * Suppliers.discount / 100.0)), 
					Suppliers.co_name, Product_Supplier.supplier_id 
					INTO v_name, v_price, v_co_name, v_supplier_id
	          FROM Product_Supplier, Suppliers, Products
	          WHERE Product_Supplier.pid = NEW.pid
	          AND Product_Supplier.supplier_id = Suppliers.supplier_id
	          AND Products.pid = NEW.pid
	          GROUP BY Product_Supplier.supplier_id, Suppliers.co_name,Products.name,Products.pid;


	          v_price := trunc(v_price,2);
	          
			--print a message
			RAISE NOTICE 'Time to restock on %, product number: %. The lowest price for this product is %
				from %.', v_name, NEW.pid, v_price, v_co_name;

			--insert this notice into the restock table
			INSERT INTO Restock(supplierID,pid,qty,price) VALUES
			(v_supplier_id, NEW.pid, total, v_price);
		END IF;
		RETURN NEW;
	END;
	$$
	LANGUAGE 'plpgsql';


CREATE TRIGGER restock 
	AFTER UPDATE ON Product_Supplier
	FOR EACH ROW
	EXECUTE PROCEDURE restock();