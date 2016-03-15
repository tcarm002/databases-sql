/**************************
 *
 *  Cart Items functions
 *
 **************************/
--Create a new cart item
CREATE OR REPLACE FUNCTION create_cartitem(v_qty INTEGER,
  v_pid INTEGER,
  v_sid INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS cartID
DECLARE v_cartID INTEGER;
BEGIN
  INSERT INTO Cart_Items (qty,pid,sid)
    SELECT v_qty,v_pid,v_sid
  WHERE NOT EXISTS(
    SELECT 1
    FROM Cart_Items
    WHERE pid = v_pid
      AND sid = v_sid
  )
  RETURNING cartID INTO v_cartID;
RETURN v_cartID;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Cart_Items;
SELECT create_cartitem(55,1,3);
SELECT * FROM Cart_Items;

--------------------------------------------------------------------------------------------------------------

--Updates cart item information. Must specify the sid.
CREATE OR REPLACE FUNCTION update_cartitem(v_cartID INTEGER,
  v_qty INTEGER DEFAULT NULL,
  v_pid INTEGER DEFAULT NULL,
  v_sid INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_cartID IS NULL THEN
    RAISE WARNING 'Please supply cartID.';
  ELSE
    UPDATE Cart_Items
    SET     qty  = COALESCE(v_qty, qty),
            pid  = COALESCE(v_pid, pid),
            sid  = COALESCE(v_sid, sid)
    WHERE cartID = v_cartID;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Cart_Items;
SELECT update_cartitem(6,105);


--------------------------------------------------------------------------------------------------------------

--Delete cart item, requires cartID or cart item info;
CREATE OR REPLACE FUNCTION delete_cartitem(v_cartID INTEGER DEFAULT NULL,
  v_qty INTEGER DEFAULT NULL,
  v_pid INTEGER DEFAULT NULL,
  v_sid INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_cartID INTEGER := v_cartID;
BEGIN
  --Populates cartID if user is supplying only item info. 
  IF v_cartID is NULL THEN
    SELECT cartID INTO v_cartID
    FROM Cart_Items
    WHERE     pid = v_pid
      AND   v_sid = v_sid;
  END IF;

    DELETE FROM Cart_Items 
          WHERE cartID = v_cartID ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Cart_Items;
SELECT delete_cartitem(1);
SELECT * FROM Cart_Items;
SELECT delete_cartitem(NULL,105,1,3);