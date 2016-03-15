/**************************
 *
 *	Suppliers functions
 *
 **************************/
 --Create a new supplier
CREATE OR REPLACE FUNCTION create_supplier(v_co_name VARCHAR(45),
 v_discount INTEGER,
 v_rep_lname varchar(45), 
 v_rep_fname varchar(45), 
 v_rep_contact varchar(45),
 v_aid INTEGER) 
RETURNS INTEGER AS
$func$
DECLARE
	v_supplier_id INTEGER;
BEGIN
	-- --Insert Supplier
	INSERT INTO Suppliers (co_name,discount,rep_lname,rep_fname,rep_contact,aid)
		 VALUES (v_co_name,v_discount,v_rep_lname,v_rep_fname,v_rep_contact,v_aid)
	RETURNING supplier_id INTO v_supplier_id;
RETURN v_supplier_id;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT create_supplier('Abby INC',
 2,
 'Catsquillo', 
 'Abby', 
 '3054449090',
 1) ;


--------------------------------------------------------------------------------------------------------------

--Updates supplier information. Must specify the company name or id.
CREATE OR REPLACE FUNCTION update_supplier(v_supplier_id INTEGER DEFAULT NULL,
	v_co_name VARCHAR(45) DEFAULT NULL, 
	v_discount INTEGER DEFAULT NULL, 
	v_rep_lname VARCHAR(45) DEFAULT NULL, 
	v_rep_fname VARCHAR(45) DEFAULT NULL, 
	v_rep_contact VARCHAR(45) DEFAULT NULL, 
	v_Addresses_aid INTEGER DEFAULT NULL) 
	--dynamically update addr infor
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
	IF v_supplier_id IS NULL AND v_co_name IS NULL THEN
		RAISE WARNING 'Please supply either supplier_id or co_name.';
	ELSE
		UPDATE Suppliers
	    SET 
	    	co_name       = COALESCE(v_co_name, co_name),
	       	discount      = COALESCE(v_discount, discount),
	       	rep_lname     = COALESCE(v_rep_lname, rep_lname),
	       	rep_fname     = COALESCE(v_rep_fname, rep_fname),
	       	rep_contact   = COALESCE(v_rep_contact, rep_contact),
	       	Addresses_aid = COALESCE(v_Addresses_aid, Addresses_aid)
	 	WHERE 	 supplier_id = v_supplier_id OR co_name = v_co_name;
 	END IF;
 	--delete unecessary address information?

 	RETURN FOUND; --Indicates whether supplier was modified
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Suppliers;
SELECT update_supplier(5,'Black Cleaning');
SELECT * FROM Suppliers;
SELECT update_supplier(5, 	NULL,  	NULL,  	NULL,  	NULL,  	'77777',  	NULL);
SELECT * FROM Suppliers;

--------------------------------------------------------------------------------------------------------------

--Delete Supplier, requires co_name or supplier_id;
CREATE OR REPLACE FUNCTION delete_supplier(v_supplier_id INTEGER DEFAULT NULL,
	v_co_name VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
BEGIN
	DELETE FROM Suppliers 
		  WHERE supplier_id	 = v_supplier_id 
	        OR co_name= v_co_name;
	RETURN FOUND; --Indicates whether supplier was deleted.
END;
$$;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Suppliers;
SELECT delete_supplier(1);
SELECT * FROM Suppliers;
