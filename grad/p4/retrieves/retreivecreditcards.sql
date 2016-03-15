/********************************
 *
 *  Retrieve Credit Cards functions
 *
 ********************************/
 --Find a credit card
CREATE OR REPLACE FUNCTION retrieve_creditcards(v_cc_id INTEGER)
RETURNS TABLE(v_cc_id INTEGER,
  v_cc_co VARCHAR(45),
  v_exp_y INTEGER,
  v_exp_m INTEGER,
  v_num VARCHAR(16),
  v_defaultCC BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER) AS
$func$
-- RETURNS credit card info of given cc_id
BEGIN
   	RETURN QUERY
    SELECT Credit_Cards.cc_id,
         Credit_Cards.cc_co,
    	   Credit_Cards.exp_y,
    	   Credit_Cards.exp_m,
    	   Credit_Cards.num,
    	   Credit_Cards.defaultCC,
    	   Credit_Cards.aid,
    	   Credit_Cards.customerID 
	FROM Credit_Cards
	WHERE cc_id=v_cc_id;
END;
$func$ LANGUAGE plpgsql;


---------------------------
--Sample calling function--
---------------------------
select retrieve_creditcards(1);

------------------------------------------------------------------------

 --Find all credit cards in the database
CREATE OR REPLACE FUNCTION retrieve_creditcards_all()
RETURNS TABLE(v_cc_id INTEGER,
  v_cc_co VARCHAR(45),
  v_exp_y INTEGER,
  v_exp_m INTEGER,
  v_num VARCHAR(16),
  v_defaultCC BOOLEAN,
  v_aid INTEGER,
  v_customerID INTEGER ) AS
$func$
BEGIN
   	RETURN QUERY
    SELECT Credit_Cards.cc_id,
         Credit_Cards.cc_co,
    	   Credit_Cards.exp_y,
    	   Credit_Cards.exp_m,
    	   Credit_Cards.num,
    	   Credit_Cards.defaultCC,
    	   Credit_Cards.aid,
    	   Credit_Cards.customerID 
	FROM Credit_Cards;
END;
$func$ LANGUAGE plpgsql;

---------------------------
--Sample calling function--
---------------------------
select retrieve_creditcards_all();