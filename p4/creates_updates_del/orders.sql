/**************************
 *
 *  Orders functions
 *
 **************************/
--Create a new order entry
CREATE OR REPLACE FUNCTION create_order(v_date DATE,
  v_customerID INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS oid
DECLARE v_oid INTEGER;
BEGIN
  INSERT INTO Orders ( date, customerID)
    SELECT v_date, v_customerID
  RETURNING oid INTO v_oid;
RETURN v_oid;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Orders;
SELECT create_order('2016-1-1',1);
SELECT * FROM Orders;

--------------------------------------------------------------------------------------------------------------

--Updates product supplier information. Must specify the oid.
CREATE OR REPLACE FUNCTION update_order(v_oid INTEGER,
  v_date DATE DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_oid IS NULL THEN
    RAISE WARNING 'Please supply oid.';
  ELSE
    UPDATE Orders
    SET 
                  date = COALESCE(v_date, date),
          customerID  = COALESCE(v_customerID, customerID)
    WHERE         oid = v_oid;
  END IF;

  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Orders;
SELECT update_order(7,'2017-1-1');


--------------------------------------------------------------------------------------------------------------

--Delete order, requires oid ;
CREATE OR REPLACE FUNCTION delete_order(v_oid INTEGER)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
BEGIN
  --Checks first if order is used in any Return records ,
  --if so, does not delete.
  IF EXISTS(
    SELECT oid FROM RETURNS WHERE oid = v_oid) 
  THEN
    RAISE WARNING 'Cannot delete since there is a return associated with
      this record. Please remove return record associated with this oid first.';
  ELSE
    DELETE FROM Orders 
          WHERE oid = v_oid ;
  END IF; 
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Orders;
SELECT delete_order(7);
SELECT * FROM Orders;
