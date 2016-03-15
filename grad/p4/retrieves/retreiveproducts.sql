/********************************
 *
 *  Retrieve Products functions
 *
 ********************************/
 --Find a Product
CREATE OR REPLACE FUNCTION retrieve_products(v_pid INTEGER)
RETURNS TABLE(v_pid INTEGER ,
  v_name VARCHAR(45),
  v_hazardous BOOLEAN ,
  v_weight NUMERIC ,
  v_version VARCHAR(45) ,
  v_description VARCHAR(45) ,
  v_combine_ship BOOLEAN ,
  v_picture VARCHAR(45),
  v_size VARCHAR(45),
  v_low_inv_thresh INTEGER ,
  v_categoryId INTEGER ) AS
$func$
-- RETURNS product of given pid
BEGIN
   	RETURN QUERY
    SELECT Products.pid,
           Products.name,
    	   Products.hazardous,
    	   Products.weight,
           Products.version,
           Products.description,
           Products.combine_ship,
           Products.picture,
           Products.size,
           Products.low_inv_thresh,
           Products.categoryId
	FROM Products
	WHERE pid=v_pid;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_products(1);

------------------------------------------------------------------------

 --Find all categories
CREATE OR REPLACE FUNCTION retrieve_products_all()
RETURNS TABLE(v_pid INTEGER ,
  v_name VARCHAR(45),
  v_hazardous BOOLEAN ,
  v_weight NUMERIC ,
  v_version VARCHAR(45) ,
  v_description VARCHAR(45) ,
  v_combine_ship BOOLEAN ,
  v_picture VARCHAR(45),
  v_size VARCHAR(45),
  v_low_inv_thresh INTEGER ,
  v_categoryId INTEGER  ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Products.pid,
           Products.name,
           Products.hazardous,
           Products.weight,
           Products.version,
           Products.description,
           Products.combine_ship,
           Products.picture,
           Products.size,
           Products.low_inv_thresh,
           Products.categoryId
    FROM Products;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_products_all();