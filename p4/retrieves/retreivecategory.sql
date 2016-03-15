/********************************
 *
 *  Retrieve Category functions
 *
 ********************************/
 --Find a category
CREATE OR REPLACE FUNCTION retrieve_category(v_categoryId INTEGER)
RETURNS TABLE(v_categoryId INTEGER,
  v_name VARCHAR(45),
  v_level VARCHAR(45),
  v_parentId INTEGER ) AS
$func$
-- RETURNS category of given categoryId
BEGIN
   	RETURN QUERY
    SELECT Category.categoryId,
           Category.name,
    	   Category.level,
    	   Category.parentId
	FROM Category
	WHERE categoryId=v_categoryId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_category(1);

------------------------------------------------------------------------

 --Find all categories
CREATE OR REPLACE FUNCTION retrieve_category_all()
RETURNS TABLE(v_categoryId INTEGER,
  v_name VARCHAR(45),
  v_level VARCHAR(45),
  v_parentId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Category.categoryId,
           Category.name,
           Category.level,
           Category.parentId
    FROM Category;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_category_all();