/**************************
 *
 *	Customer functions
 *
 **************************/
--Create a new customer
CREATE OR REPLACE FUNCTION create_customer(v_email VARCHAR(60),
 v_phone varchar(15), 
 v_fname varchar(45),
 v_mname varchar(45), 
 v_lname varchar(45), 
 v_password varchar(45)) 
RETURNS INTEGER AS
$func$
DECLARE
	v_store_credit_bal NUMERIC := 0.0;
	v_customerID INTEGER;
BEGIN
	INSERT INTO Customer (email,phone,fname,mname,lname,password,store_credit_bal)
	SELECT v_email,v_phone,v_fname,v_mname,v_lname,v_password,v_store_credit_bal
		WHERE NOT EXISTS(
		    SELECT 1
		    FROM Customer
		    WHERE email=v_email
		    	AND phone=v_phone
		    	AND	fname=v_fname
		    	AND	mname=v_mname
		    	AND	lname=v_lname
		    	AND	password=v_password
		    	AND	store_credit_bal=v_store_credit_bal
	)
	RETURNING customerID INTO v_customerID;
	
RETURN v_customerID;
END;
$func$ LANGUAGE plpgsql;


SELECT * FROM Customer;
SELECT create_customer('Po@hotmail.com','3053480136','Bill','Baxter','123',NULL );
--insert overloaded function for optional mname arg

--------------------------------------------------------------------------------------------------------------

--Updates customer information. Must specify the customers email address.
CREATE OR REPLACE FUNCTION update_customer(v_customerID INTEGER,
	v_email VARCHAR(60), 
	v_phone varchar(15) DEFAULT NULL, 
	v_fname varchar(45) DEFAULT NULL, 
	v_mname varchar(45) DEFAULT NULL, 
	v_lname varchar(45) DEFAULT NULL, 
	v_password varchar(45) DEFAULT NULL,
	v_store_credit_bal NUMERIC DEFAULT NULL) 
RETURNS VOID AS 
$FUNC$
BEGIN
	UPDATE customer
    SET 
    	email 	   = COALESCE(v_email, email),
    	phone 	   = COALESCE(v_phone,phone),
    	fname      = COALESCE(v_fname, fname),
       	mname      = COALESCE(v_mname, mname),
       	lname      = COALESCE(v_lname, lname),
       	password   = COALESCE(v_password, password),
       	store_credit_bal = COALESCE(v_store_credit_bal,store_credit_bal)
 	WHERE 	 customerID = v_customerID;
 	-- RETURN FOUND;
END;
$FUNC$ LANGUAGE plpgsql;



--------------------------------------------------------------------------------------------------------------

--Delete customer, requires email;
CREATE OR REPLACE FUNCTION delete_customer(v_email VARCHAR(60), v_password varchar(45))
RETURNS VOID AS 
$func$
BEGIN
	DELETE FROM customer 
		  WHERE email 	 = v_email 
	        AND password = v_password;
END;
$func$ LANGUAGE plpgsql;



-- Function calls


SELECT update_customer(email := 'Po@hotmail.com', fname := 'CIci');

select delete_customer('Po@hotmail.com','123');

