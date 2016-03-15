/**************************
 *
 *  Returns functions
 *
 **************************/
--Create a new return
CREATE OR REPLACE FUNCTION create_return(v_date DATE,
  v_partial BOOLEAN,
  v_refunded_amt NUMERIC,
  v_status VARCHAR(45),
  v_customerID INTEGER ,
  v_oid INTEGER ,
  v_cc_id INTEGER )
RETURNS INTEGER AS
$func$
-- RETURNS rma
DECLARE v_rma INTEGER;
BEGIN
  INSERT INTO Returns (date,partial,refunded_amt,status,customerID,oid,cc_id)
    SELECT v_date,v_partial,v_refunded_amt,v_status,v_customerID,v_oid,v_cc_id
  WHERE NOT EXISTS(
    SELECT 1
    FROM Returns
    WHERE date = v_date
      AND partial = v_partial
      AND refunded_amt = v_refunded_amt
	  AND status = v_status
	  AND customerID = v_customerID
	  AND oid = v_oid
	  AND cc_id = v_cc_id
  )
  RETURNING rma INTO v_rma;
RETURN v_rma;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Returns;
SELECT create_return('2015-12-31','0',2500, 'Complete',1,1,1);
SELECT * FROM Returns;

--------------------------------------------------------------------------------------------------------------

--Updates return information. Must specify the rma.
CREATE OR REPLACE FUNCTION update_return(v_rma INTEGER,
  v_date DATE DEFAULT NULL,
  v_partial BOOLEAN DEFAULT NULL,
  v_refunded_amt NUMERIC DEFAULT NULL,
  v_status VARCHAR(45) DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_cc_id INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
  IF v_rma IS NULL THEN
    RAISE WARNING 'Please supply rma.';
  ELSE
    UPDATE Returns
    SET     date  		  = COALESCE(v_date, date),
            partial  	  = COALESCE(v_partial, partial),
            refunded_amt  = COALESCE(v_refunded_amt, refunded_amt),
            status  	  = COALESCE(v_status, status),
            customerID    = COALESCE(v_customerID, customerID),
            oid  		  = COALESCE(v_oid, oid),
            cc_id  		  = COALESCE(v_cc_id, cc_id)
    WHERE rma = v_rma;
  END IF;
  RETURN FOUND; 
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Returns;
SELECT update_return(6,NULL,NULL,NULL,NULL,NULL,NULL,2);


--------------------------------------------------------------------------------------------------------------

--Delete return, requires rma or cart item info;
CREATE OR REPLACE FUNCTION delete_return(v_rma INTEGER DEFAULT NULL,
  v_date DATE DEFAULT NULL,
  v_partial BOOLEAN DEFAULT NULL,
  v_refunded_amt NUMERIC DEFAULT NULL,
  v_status VARCHAR(45) DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL,
  v_oid INTEGER DEFAULT NULL,
  v_cc_id INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
  v_rma INTEGER := v_rma;
BEGIN
  --Populates rma if user is supplying only item info. 
  IF v_rma is NULL THEN
    SELECT rma INTO v_rma
    FROM Returns
    WHERE   		date = v_date
      AND   	 partial = v_partial
      AND 	refunded_amt = v_refunded_amt
      AND   	  status = v_status
      AND     customerID = v_customerID
      AND   		 oid = v_oid
      AND   	   cc_id = v_cc_id;
  END IF;

    --must delete items from return list first
  	DELETE FROM Return_List
  	WHERE rma = v_rma;

  	--Then delete return
    DELETE FROM Returns 
          WHERE rma = v_rma ;
  
  RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Returns;
SELECT delete_return(1);
SELECT * FROM Returns;
SELECT delete_cartitem(NULL,105,1,3);