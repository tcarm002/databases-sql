/**************************
 *
 *  Products functions
 *
 **************************/
--Create a new product entry
CREATE OR REPLACE FUNCTION create_product(v_name VARCHAR(45),
  v_hazardous BOOLEAN,
  v_weight NUMERIC ,
  v_version VARCHAR(45) ,
  v_description VARCHAR(45) ,
  v_combine_ship BOOLEAN ,
  v_low_inv_thresh INTEGER ,
  v_categoryId INTEGER,
  v_picture VARCHAR(45) DEFAULT NULL,
  v_size VARCHAR(45) DEFAULT NULL)
RETURNS INTEGER AS
$func$
-- RETURNS PID
DECLARE v_pid INTEGER;
BEGIN
  INSERT INTO Products (name,
    hazardous ,
    weight  ,
    version  ,
    description ,
    combine_ship ,
    picture ,
    size,
    low_inv_thresh ,
    categoryId)
    SELECT v_name,
    v_hazardous,
    v_weight  ,
    v_version ,
    v_description ,
    v_combine_ship ,
    v_picture,
    v_size,
    v_low_inv_thresh,
    v_categoryId 
  WHERE NOT EXISTS(
    SELECT 1
    FROM Products
    WHERE name           = v_name
      AND hazardous      = v_hazardous
      AND weight         = v_weight 
      AND version        = v_version
      AND description    = v_description
      AND combine_ship   = v_combine_ship
      AND picture        = v_picture
      AND size           = v_size
      AND low_inv_thresh = v_low_inv_thresh
      AND categoryId     = v_categoryId
  )
  RETURNING pid INTO v_pid;
RETURN v_pid;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Products;
SELECT create_product('Banana Pencil','0',0.02,'1','A banana themed pencil','1',400,2,'webshop.com/bpencil','Tiny');
SELECT * FROM Products;
SELECT create_product('Guava Pencil','0',0.02,'1','A guava themed pencil','1',400,2,'webshop.com/bpencil','Tiny');

--------------------------------------------------------------------------------------------------------------

--Updates product information. Must specify the pid.
CREATE OR REPLACE FUNCTION update_product(v_pid INTEGER,
  v_name VARCHAR(45) DEFAULT NULL,
  v_hazardous BOOLEAN DEFAULT NULL,
  v_weight NUMERIC DEFAULT NULL,
  v_version VARCHAR(45) DEFAULT NULL,
  v_description VARCHAR(45) DEFAULT NULL,
  v_combine_ship BOOLEAN DEFAULT NULL,
  v_low_inv_thresh INTEGER DEFAULT NULL,
  v_categoryId INTEGER DEFAULT NULL,
  v_picture VARCHAR(45) DEFAULT NULL,
  v_size VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_pid IS NULL THEN
    RAISE WARNING 'Please supply pid.';
  ELSE
    UPDATE Products
      SET 
          name           = COALESCE(v_name, name),
          hazardous      = COALESCE(v_hazardous, hazardous),
          weight         = COALESCE(v_weight, weight),
          version        = COALESCE(v_version, version),
          description    = COALESCE(v_description, description),
          combine_ship   = COALESCE(v_combine_ship, combine_ship),
          low_inv_thresh = COALESCE(v_low_inv_thresh, low_inv_thresh),
          categoryId     = COALESCE(v_categoryId, categoryId),
          picture        = COALESCE(v_picture, picture),
          size           = COALESCE(v_size, size)
    WHERE        pid = v_pid;
  END IF;

  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Products;
SELECT update_product(1,'Jake');
SELECT * FROM Products;
SELECT update_product(6, NULL,NULL,NULL,NULL,NULL,NULL, NULL, NULL,'1.jpg',NULL);
SELECT * FROM Products;

--------------------------------------------------------------------------------------------------------------

--Delete Product, requires pid or complete product info;
CREATE OR REPLACE FUNCTION delete_product(v_pid INTEGER DEFAULT NULL,
  v_name VARCHAR(45) DEFAULT NULL,
  v_hazardous BOOLEAN DEFAULT NULL,
  v_weight NUMERIC DEFAULT NULL,
  v_version VARCHAR(45) DEFAULT NULL,
  v_description VARCHAR(45) DEFAULT NULL,
  v_combine_ship BOOLEAN DEFAULT NULL,
  v_low_inv_thresh INTEGER DEFAULT NULL,
  v_categoryId INTEGER DEFAULT NULL,
  v_picture VARCHAR(45) DEFAULT NULL,
  v_size VARCHAR(45) DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_pid INTEGER := v_pid;
BEGIN
  --check first if product is used in any ... records,
  --if so, do not delete, only delete reference in linking table
  IF v_pid is NULL THEN
    SELECT pid INTO v_pid 
    FROM Products
    WHERE   name           = v_name
        AND hazardous      = v_hazardous
        AND weight         = v_weight
        AND version        = v_version
        AND description    = v_description
        AND combine_ship   = v_combine_ship
        AND low_inv_thresh = v_low_inv_thresh
        AND categoryId     = v_categoryId
        AND picture        = v_picture
        AND size           = v_size;
  END IF;

    DELETE FROM Products 
            WHERE pid = v_pid ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Products;
SELECT delete_product(6);
SELECT * FROM Products;
