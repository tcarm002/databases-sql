-- -----------------------------------------------------
-- Table Item_List
-- -----------------------------------------------------
DROP TABLE IF EXISTS Item_List CASCADE;
DROP SEQUENCE IF EXISTS itemListId_seq CASCADE;
CREATE SEQUENCE itemListId_seq;

CREATE TABLE  Item_List (
  itemListId INTEGER PRIMARY KEY DEFAULT nextval('itemListId_seq'),
  returned BOOLEAN NOT NULL,
  qty INTEGER NOT NULL CHECK (qty >0),
  shipped BOOLEAN NOT NULL,
  price NUMERIC NOT NULL,
  oid INTEGER NOT NULL REFERENCES Orders (oid),
  supplierId INTEGER NOT NULL
);


/*******************************************
 *
 *  Retrieve Item List functions
 *
 *******************************************/
 --Find item list linking information
CREATE OR REPLACE FUNCTION retrieve_itemlist(v_itemListId INTEGER)
RETURNS TABLE(v_itemListId INTEGER,
  v_returned BOOLEAN,
  v_qty INTEGER,
  v_shipped BOOLEAN,
  v_price NUMERIC,
  v_oid INTEGER,
  v_supplierId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Item_List.itemListId,
      	   Item_List.returned,
           Item_List.qty,
           Item_List.shipped,
           Item_List.price,
           Item_List.oid,
           Item_List.supplierId
  	FROM Item_List
  	WHERE itemListId = v_itemListId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_itemlist(3);

------------------------------------------------------------------------

 --Find all address linking info in the database
CREATE OR REPLACE FUNCTION retrieve_itemlist_all()
RETURNS TABLE(v_itemListId INTEGER,
  v_returned BOOLEAN,
  v_qty INTEGER,
  v_shipped BOOLEAN,
  v_price NUMERIC,
  v_oid INTEGER,
  v_supplierId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Item_List.itemListId,
           Item_List.returned,
           Item_List.qty,
           Item_List.shipped,
           Item_List.price,
           Item_List.oid,
           Item_List.supplierId
    FROM Item_List;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_itemlist_all();