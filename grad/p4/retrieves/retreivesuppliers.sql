/********************************
 *
 *  Retrieve Suppliers functions
 *
 ********************************/
 --Find a supplier
CREATE OR REPLACE FUNCTION retrieve_suppliers(v_supplier_id INTEGER)
RETURNS TABLE(v_co_name VARCHAR(45),
  v_discount INTEGER,
  v_rep_lname VARCHAR(45),
  v_rep_fname VARCHAR(45),
  v_rep_contact VARCHAR(45),
  v_aid INTEGER) AS
$func$
-- RETURNS supplier info of given supplierId
BEGIN
   	RETURN QUERY
    SELECT Suppliers.co_name,
    	   Suppliers.discount,
    	   Suppliers.rep_lname,
    	   Suppliers.rep_fname,
    	   Suppliers.rep_contact,
    	   Suppliers.aid
	FROM Suppliers
	WHERE supplier_id=v_supplier_id;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_suppliers(1);

------------------------------------------------------------------------

 --Find all credit cards in the database
CREATE OR REPLACE FUNCTION retrieve_suppliers_all()
RETURNS TABLE(v_supplier_id INTEGER,
  v_co_name VARCHAR(45),
  v_discount INTEGER,
  v_rep_lname VARCHAR(45),
  v_rep_fname VARCHAR(45),
  v_rep_contact VARCHAR(45),
  v_aid INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Suppliers.supplier_id,
    	   Suppliers.co_name,
    	   Suppliers.discount,
    	   Suppliers.rep_lname,
    	   Suppliers.rep_fname,
    	   Suppliers.rep_contact,
    	   Suppliers.aid
	FROM Suppliers;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_suppliers_all();