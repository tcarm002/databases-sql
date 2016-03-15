/********************************
 *
 *  Retrieve Returns
 *
 ********************************/
 --Find Returns
CREATE OR REPLACE FUNCTION retrieve_returns(v_rma INTEGER)
RETURNS TABLE(v_rma INTEGER,
  v_date DATE,
  v_partial BOOLEAN,
  v_refunded_amt NUMERIC,
  v_status VARCHAR(45),
  v_customerID INTEGER,
  v_oid INTEGER,
  v_cc_id INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Returns.rma,
           Returns.date,
           Returns.partial,
           Returns.refunded_amt,
           Returns.status,
           Returns.customerID,
           Returns.oid,
           Returns.cc_id
  	FROM Returns
  	WHERE rma=v_rma;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_returns(1);

------------------------------------------------------------------------

 --Find all product suppliers
CREATE OR REPLACE FUNCTION retrieve_returns_all()
RETURNS TABLE(v_rma INTEGER,
  v_date DATE,
  v_partial BOOLEAN,
  v_refunded_amt NUMERIC,
  v_status VARCHAR(45),
  v_customerID INTEGER,
  v_oid INTEGER,
  v_cc_id INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Returns.rma,
           Returns.date,
           Returns.partial,
           Returns.refunded_amt,
           Returns.status,
           Returns.customerID,
           Returns.oid,
           Returns.cc_id
    FROM Returns;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_returns_all();