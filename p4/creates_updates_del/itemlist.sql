/**********************************
 *
 *  Item List functions
 *
 ***********************************/
--Create a new customer address link
CREATE OR REPLACE FUNCTION create_itemlist(v_returned BOOLEAN,
  v_qty INTEGER,
  v_shipped BOOLEAN,
  v_price NUMERIC,
  v_oid INTEGER,
  v_supplierId INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS itemListId
DECLARE v_itemListId INTEGER;
BEGIN
  INSERT INTO Item_List (returned,qty,shipped,price,oid,supplierId)
    SELECT v_returned,v_qty,v_shipped,v_price,v_oid,v_supplierId
  WHERE NOT EXISTS(
    SELECT 1
    FROM Item_List
    WHERE 			returned = v_returned
    	AND 			qty  = v_qty
    	AND 		 shipped = v_shipped
    	AND            price = v_price
    	AND              oid = v_oid
    	AND       supplierId = v_supplierId
  )
  RETURNING itemListId INTO v_itemListId;
RETURN v_itemListId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Item_List;
SELECT create_itemlist('0',55,'1',.99,5,1);
SELECT * FROM Item_List;

--------------------------------------------------------------------------------------------------------------

--Updates item list information. Must specify the itemListId.
CREATE OR REPLACE FUNCTION update_itemlist(v_itemListId INTEGER,
  v_returned BOOLEAN DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_shipped BOOLEAN DEFAULT NULL,
  v_price NUMERIC DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_supplierId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_itemListId IS NULL THEN
    RAISE WARNING 'Please supply itemListId.';
  ELSE
    UPDATE Item_List
    SET     returned  = COALESCE(v_returned , returned),
    			 qty  = COALESCE(v_qty , qty),
    	     shipped  = COALESCE(v_shipped , shipped),
    		   price  = COALESCE(v_price , price),
    			 oid  = COALESCE(v_oid , oid),
    	  supplierId  = COALESCE(v_supplierId , supplierId)
    WHERE  itemListId = v_itemListId;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Item_List;
SELECT update_itemlist(1,NULL,NULL,'1',.99,NULL,NULL);

--------------------------------------------------------------------------------------------------------------

--Delete item list information, requires itemListId or item list info;
CREATE OR REPLACE FUNCTION delete_itemlist(v_itemListId INTEGER DEFAULT NULL,
  v_returned BOOLEAN DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_shipped BOOLEAN DEFAULT NULL,
  v_price NUMERIC DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_supplierId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_itemListId INTEGER := v_itemListId;
BEGIN
  --Populates itemListId if user is supplying only item list info. 
  IF v_itemListId is NULL THEN
    SELECT itemListId INTO v_itemListId
    FROM Item_List
    WHERE   		returned = v_returned
    	AND 			qty  = v_qty
    	AND 		 shipped = v_shipped
    	AND            price = v_price
    	AND              oid = v_oid
    	AND       supplierId = v_supplierId;
  END IF;

  --check if item is in shipment list, if so do not delete
  IF EXISTS(SELECT * FROM Shipment_List WHERE itemListId = v_itemListId) 
  THEN
  	RAISE WARNING 'Cannot delete, since item is referenced in shipment list';
	ELSE
    DELETE FROM Item_List 
          WHERE itemListId = v_itemListId ;
  END IF;
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Item_List;
SELECT delete_itemlist(8);
SELECT * FROM Item_List;
