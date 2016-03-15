/**************************
 *
 *	Categories functions
 *
 **************************/
--Create a new category entry
CREATE OR REPLACE FUNCTION create_category(v_name VARCHAR(45),
  v_level VARCHAR(45),
  v_parentId INTEGER)
RETURNS INTEGER AS
$func$
-- RETURNS categoryId
DECLARE v_categoryId INTEGER;
BEGIN
	INSERT INTO Category (name,level,parentId)
	SELECT v_name,v_level,v_parentId
	WHERE NOT EXISTS(
		SELECT 1
		FROM Category
		WHERE name      = v_name
		  AND level     = v_level 
		  AND parentId  = v_parentId
	)
	RETURNING categoryId INTO v_categoryId;
RETURN v_categoryId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Category;
SELECT create_category('Audio Players','2',3);
SELECT * FROM Category;

--------------------------------------------------------------------------------------------------------------

--Updates category information. Must specify the category id.
CREATE OR REPLACE FUNCTION update_category(v_categoryId INTEGER,
  v_name VARCHAR(45) DEFAULT NULL,
  v_level VARCHAR(45) DEFAULT NULL,
  v_parentId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
	IF v_categoryId IS NULL THEN
		RAISE WARNING 'Please supply categoryId.';
	ELSE
		UPDATE Category
	    SET 
	    	name          = COALESCE(v_name, name),
	       	level         = COALESCE(v_level, level),
	       	parentId      = COALESCE(v_parentId, parentId)
	 	WHERE  categoryId = v_categoryId;
 	END IF;

 	RETURN FOUND; --Indicates whether credit card was modified
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Category;
SELECT update_category(3,'Small Electronics');
SELECT * FROM Category;
SELECT update_category(6, NULL,NULL, 1);
SELECT * FROM Credit_Cards;

--------------------------------------------------------------------------------------------------------------

--Delete a category, requires categoryId or complete category info;
CREATE OR REPLACE FUNCTION delete_category(v_categoryId INTEGER DEFAULT NULL,
  v_name VARCHAR(45) DEFAULT NULL,
  v_level VARCHAR(45) DEFAULT NULL,
  v_parentId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
	v_categoryId INTEGER := v_categoryId;
BEGIN
	--check first if category is used in any ..... records,
	--if so, do not delete, only delete reference in linking table
	IF v_categoryId is NULL THEN
		SELECT categoryId INTO v_categoryId
		FROM Category
		WHERE 	name     = v_name
	    	AND level    = v_level
	    	AND parentId = v_parentId;
	END IF;

	IF EXISTS(
		SELECT categoryId FROM Category WHERE parentId = v_categoryId) 
	OR
		EXISTS(
		SELECT categoryId FROM Products WHERE categoryId = v_categoryId) 
	THEN
		RAISE WARNING 'Category information cannot be deleted since it is 
					associated with a product or is the parent of another 
					category.';
	ELSE
		DELETE FROM Category 
	          WHERE categoryId = v_categoryId ;
	END IF;

	
	RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Category;
SELECT delete_category(6);
SELECT * FROM Category;
