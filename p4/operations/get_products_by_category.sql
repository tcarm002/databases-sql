/*******************************************
 *
 *  Get Products By Category function
 *
 *******************************************/
CREATE OR REPLACE FUNCTION get_products_by_category(v_categoryId INTEGER)
RETURNS TABLE (pid INTEGER,name VARCHAR(45)) AS 
$func$
tmp TABLE(pid INTEGER,name VARCHAR(45);
BEGIN
	IF EXISTS(
		  SELECT Products.pid,Products.name 
		  FROM Products 
		  WHERE Products.categoryId = v_categoryId)
	THEN
		RETURN QUERY SELECT Products.pid,Products.name
		FROM Products
		WHERE Products.categoryId = v_categoryId;
	END IF;


  IF EXISTS(select get_products_by_category(v_categoryId) )
  THEN 
  	SELECT get_products_by_category(v_categoryId) INTO tmp;
  	RETURN tmp;
  END IF;


END;
$func$ LANGUAGE plpgsql;


/*******************************************
 *
 *  TEST
 *
 *******************************************/

 select get_products_by_category(2);