/**************************
 *
 *  Returns functions
 *
 **************************/
--Create a new return
CREATE OR REPLACE FUNCTION create_returnlist(v_qty INTEGER,
  v_rma INTEGER,
  v_itemListId INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS returnListId
DECLARE v_returnListId INTEGER;
BEGIN
  INSERT INTO Return_List (qty,rma,itemListId)
       SELECT v_qty,v_rma,v_itemListId
  WHERE NOT EXISTS(
    SELECT 1
    FROM Return_List
    WHERE qty = v_qty
      AND rma = v_rma
      AND itemListId = v_itemListId
  )
  RETURNING returnListId INTO v_returnListId;
RETURN v_returnListId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Return_List;
SELECT create_returnlist(205,5,1);
SELECT * FROM Return_List;

--------------------------------------------------------------------------------------------------------------

--Updates return list information. Must specify the returnListId.
CREATE OR REPLACE FUNCTION update_returnlist(v_returnListId INTEGER,
  v_qty INTEGER DEFAULT NULL,
  v_rma INTEGER DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_returnListId IS NULL THEN
    RAISE WARNING 'Please supply returnListId.';
  ELSE
    UPDATE Return_List
    SET     qty  		= COALESCE(v_qty, qty),
            rma  	  	= COALESCE(v_rma, rma),
            itemListId  = COALESCE(v_itemListId, itemListId)
    WHERE returnListId = v_returnListId;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Return_List;
SELECT update_returnlist(7,NULL,2,NULL);
SELECT * FROM Return_List;


--------------------------------------------------------------------------------------------------------------

--Delete return list item, requires returnListId or item info;
CREATE OR REPLACE FUNCTION delete_returnlist(v_returnListId INTEGER DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_rma INTEGER DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_returnListId INTEGER := v_returnListId;
BEGIN
  --Populates returnListId if user is supplying only item info. 
  IF v_returnListId is NULL THEN
    SELECT returnListId INTO v_returnListId
    FROM Return_List
    WHERE   	   qty = v_qty
      AND   	   rma = v_rma
      AND 	itemListId = v_itemListId;
  END IF;

    DELETE FROM Return_List 
          WHERE returnListId = v_returnListId ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Return_List;
SELECT delete_returnlist(7);
SELECT * FROM Return_List;