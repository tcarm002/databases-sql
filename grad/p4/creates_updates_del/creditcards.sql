/**************************
 *
 *	Credit Cards functions
 *
 **************************/
--Create a new credit card entry
CREATE OR REPLACE FUNCTION create_creditcard(v_cc_co VARCHAR(45),
  v_exp_y INTEGER,
  v_exp_m INTEGER,
  v_num VARCHAR(16),
  v_defaultCC BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER DEFAULT NULL)
RETURNS INTEGER AS
$func$
-- RETURNS cc_id
DECLARE v_cc_id INTEGER;
BEGIN
	INSERT INTO Credit_Cards (cc_co,exp_y,exp_m,num,defaultCC,aid,customerID)
	SELECT v_cc_co,v_exp_y,v_exp_m,v_num,v_defaultCC,v_aid,v_customerID
	WHERE NOT EXISTS(
		SELECT 1
		FROM Credit_Cards
		WHERE cc_co      = v_cc_co
		  AND exp_y      = v_exp_y 
		  AND exp_m      = v_exp_m
		  AND num        = v_num
		  AND defaultCC  = v_defaultCC
		  AND aid        = v_aid
		  AND customerID = v_customerID
	)
	RETURNING cc_id INTO v_cc_id;
RETURN v_cc_id;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Credit_Cards;
SELECT create_creditcard('MC', '2016', '09','9000101010101010', '0' , 5 , 5);
SELECT * FROM Credit_Cards;

--------------------------------------------------------------------------------------------------------------

--Updates credit card information. Must specify the cc_id.
CREATE OR REPLACE FUNCTION update_creditcard(v_cc_id INTEGER,
  v_cc_co VARCHAR(45) DEFAULT NULL,
  v_exp_y INTEGER DEFAULT NULL,
  v_exp_m INTEGER DEFAULT NULL,
  v_num VARCHAR(16) DEFAULT NULL,
  v_defaultCC BOOLEAN DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS 
$$
BEGIN
	IF v_cc_id IS NULL THEN
		RAISE WARNING 'Please supply cc_id.';
	ELSE
		UPDATE Credit_Cards
	    SET 
	    	cc_co          = COALESCE(v_cc_co, cc_co),
	       	exp_y          = COALESCE(v_exp_y, exp_y),
	       	exp_m          = COALESCE(v_exp_m, exp_m),
	       	num            = COALESCE(v_num, num),
	       	defaultCC      = COALESCE(v_defaultCC, defaultCC),
	       	aid            = COALESCE(v_aid, aid),
	       	customerID     = COALESCE(v_customerID, customerID)
	 	WHERE 	     cc_id = v_cc_id;
 	END IF;

 	RETURN FOUND; --Indicates whether credit card was modified
END;
$$ ;

---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Credit_Cards;
SELECT update_creditcard(1,'BARCLAY');
SELECT * FROM Credit_Cards;
SELECT update_creditcard(6, NULL,  	NULL,  	NULL,  	NULL,  	NULL, NULL,  1);
SELECT * FROM Credit_Cards;

--------------------------------------------------------------------------------------------------------------

--Delete Credit Card, requires cc_id or complete credit card info;
CREATE OR REPLACE FUNCTION delete_creditcard(v_cc_id INTEGER DEFAULT NULL,
  v_cc_co VARCHAR(45) DEFAULT NULL,
  v_exp_y INTEGER DEFAULT NULL,
  v_exp_m INTEGER DEFAULT NULL,
  v_num VARCHAR(16) DEFAULT NULL,
  v_defaultCC BOOLEAN DEFAULT NULL,
  v_aid INTEGER DEFAULT NULL,
  v_customerID INTEGER DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE plpgsql VOLATILE SECURITY DEFINER AS $$
DECLARE
	v_cc_id INTEGER := v_cc_id;
BEGIN
	--check first if address is used in any credit card or shipment records,
	--if so, do not delete, only delete reference in linking table
	IF v_cc_id is NULL THEN
		SELECT cc_id INTO v_cc_id 
		FROM Credit_Cards
		WHERE 	street     = v_cc_co
	    	AND city       = v_exp_y
	    	AND country    = v_exp_m
	    	AND zip        = v_num
	    	AND state      = v_defaultCC
	    	AND apt        = v_aid
	    	AND customerID =v_customerID;
	END IF;

	IF EXISTS(
		SELECT cc_id FROM Orders WHERE cc_id = v_cc_id) 
	THEN
		RAISE WARNING 'Credit card information will remain in database since it is related
			to a an existing order record. However, linking info will
			be deleted.';
	ELSE
		DELETE FROM Credit_Cards 
	          WHERE cc_id = v_cc_id ;
	END IF;

	UPDATE Credit_Cards
	SET    defaultCC      = '0',
	       customerID     = NULL
	WHERE 	        cc_id = v_cc_id;
	
	RETURN FOUND; 
END;
$$;


---------------------------
--Sample calling function--
---------------------------
SELECT * FROM Credit_Cards;
SELECT delete_creditcard(6);
SELECT * FROM Credit_Cards;
