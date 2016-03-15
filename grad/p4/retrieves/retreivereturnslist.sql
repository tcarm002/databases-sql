/********************************
 *
 *  Retrieve Returns List
 *
 ********************************/
--Find Return List items
CREATE OR REPLACE FUNCTION retrieve_returnslist(v_returnListId INTEGER)
RETURNS TABLE(v_returnListId INTEGER,
  v_qty INTEGER,
  v_rma INTEGER,
  v_itemListId INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Return_List.returnListId,
           Return_List.qty,
           Return_List.rma,
           Return_List.itemListId
  	FROM Return_List
  	WHERE returnListId=v_returnListId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_returnslist(1);

------------------------------------------------------------------------

 --Find all return list items
CREATE OR REPLACE FUNCTION retrieve_returnslist_all()
RETURNS TABLE(v_returnListId INTEGER,
  v_qty INTEGER,
  v_rma INTEGER,
  v_itemListId INTEGER) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Return_List.returnListId,
           Return_List.qty,
           Return_List.rma,
           Return_List.itemListId
    FROM Return_List;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_returnslist_all();