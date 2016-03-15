/********************************
 *
 *  Retrieve Customers functions
 *
 ********************************/
 --Find a customer entry
CREATE OR REPLACE FUNCTION retrieve_customer(v_customerID INTEGER)
RETURNS TABLE(v_customerID INTEGER,
    v_email VARCHAR(60),
	v_phone VARCHAR(15),
    v_fname VARCHAR(45),
    v_mname VARCHAR(45),
    v_lname VARCHAR(45),
    v_password VARCHAR(45), 
    v_store_credit_bal NUMERIC) AS
$func$
-- RETURNS customer info of given customerID
BEGIN
   	RETURN QUERY
    SELECT Customer.customerID,
           Customer.email,
    	   Customer.phone,
    	   Customer.fname,
    	   Customer.mname,
    	   Customer.lname,
    	   Customer.password,
    	   Customer.store_credit_bal 
	FROM Customer
	WHERE customerID=v_customerID;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_customer(1);

------------------------------------------------------------------------

 --Find all customer entries
CREATE OR REPLACE FUNCTION retrieve_customer_all()
RETURNS TABLE( v_customerID INTEGER,
    v_email VARCHAR(60),
	v_phone VARCHAR(15),
    v_fname VARCHAR(45),
    v_mname VARCHAR(45),
    v_lname VARCHAR(45),
    v_password VARCHAR(45), 
    v_store_credit_bal NUMERIC ) AS
$func$
-- RETURNS all customers in the database
BEGIN
   	RETURN QUERY
    SELECT Customer.customerID,
           Customer.email,
    	   Customer.phone,
    	   Customer.fname,
    	   Customer.mname,
    	   Customer.lname,
    	   Customer.password,
    	   Customer.store_credit_bal 
	FROM Customer;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_customer_all();