/*******************************************
 *
 *  Retrieve Exchange functions
 *
 *******************************************/
 --Find exchange information
CREATE OR REPLACE FUNCTION retrieve_exchange(v_exchangeId INTEGER)
RETURNS TABLE(v_exchangeId INTEGER,
  v_qty INTEGER,
  v_difference NUMERIC,
  v_itemListId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Exchanges.exchangeId,
      	   Exchanges.qty,
           Exchanges.difference,
           Exchanges.itemListId
  	FROM Exchanges
  	WHERE exchangeId = v_exchangeId;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_exchange(3);

------------------------------------------------------------------------

 --Find all address linking info in the database
CREATE OR REPLACE FUNCTION retrieve_exchange_all()
RETURNS TABLE(v_exchangeId INTEGER,
  v_qty INTEGER,
  v_difference NUMERIC,
  v_itemListId INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Exchanges.exchangeId,
           Exchanges.qty,
           Exchanges.difference,
           Exchanges.itemListId
    FROM Exchanges;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_shipmentlist_all();