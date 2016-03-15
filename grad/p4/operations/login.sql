/**********************************
 *
 *  Login function
 *
 ***********************************/
CREATE OR REPLACE FUNCTION login(username VARCHAR(60), 
  v_password VARCHAR(45) )
RETURNS TEXT AS 
$func$
-- RETURNS message indicating successful login or failure
DECLARE
  msg TEXT := 'Error';
BEGIN
  IF EXISTS(
    SELECT * 
    FROM Customer 
    WHERE email = username 
    AND password = v_password) 
  THEN
   msg := 'You have succesfully logged in.';
  ELSE
    msg := 'Username and password combination not found.';
  END IF;
RETURN msg;
END;
$func$ LANGUAGE plpgsql;
