/**********************************
 *
 *  Exchange functions
 *
 ***********************************/
--Create a new exchange
CREATE OR REPLACE FUNCTION create_exchange(v_qty INTEGER,
  v_difference NUMERIC,
  v_itemListId INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS exchangeId
DECLARE v_exchangeId INTEGER;
BEGIN
  INSERT INTO Exchanges (qty,difference,itemListId)
    SELECT v_qty,v_difference,v_itemListId
  WHERE NOT EXISTS(
    SELECT 1
    FROM Exchanges
    WHERE 		   qty = v_qty
    	AND   difference  = v_difference
    	AND itemListId = v_itemListId
  )
  RETURNING exchangeId INTO v_exchangeId;
RETURN v_exchangeId;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Exchanges;
SELECT create_exchange(10,10,2);
SELECT * FROM Exchanges;

--------------------------------------------------------------------------------------------------------------

--Updates exchange information. Must specify the exchangeId.
CREATE OR REPLACE FUNCTION update_exchange(v_exchangeId INTEGER,
  v_qty INTEGER DEFAULT NULL,
  v_difference NUMERIC DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL )
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_exchangeId IS NULL THEN
    RAISE WARNING 'Please supply exchangeId.';
  ELSE
    UPDATE Exchanges
	SET  		 qty  = COALESCE(v_qty , qty),
		  difference  = COALESCE(v_difference , difference),
		  itemListId  = COALESCE(v_itemListId , itemListId)
    WHERE  exchangeId = v_exchangeId;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Exchanges;
SELECT update_exchange(1,5001);

--------------------------------------------------------------------------------------------------------------

--Delete exchange, requires exchangeId or exchange info;
CREATE OR REPLACE FUNCTION delete_exchange(v_exchangeId INTEGER DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_difference NUMERIC DEFAULT NULL,
  v_itemListId INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_exchangeId INTEGER := v_exchangeId;
BEGIN
  IF v_exchangeId is NULL THEN
    SELECT exchangeId INTO v_exchangeId
    FROM Exchanges
     WHERE 		    qty = v_qty
    	AND difference  = v_difference
    	AND  itemListId = v_itemListId;
  END IF;

    DELETE FROM Exchanges 
       WHERE exchangeId = v_exchangeId ;
  RETURN FOUND; 
END;
$$;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Exchanges;
SELECT delete_exchange(1);
SELECT * FROM Exchanges;
