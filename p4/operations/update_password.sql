/**********************************
 *
 *  Update password function
 *
 ***********************************/
CREATE OR REPLACE FUNCTION update_password(username VARCHAR(60), 
  v_password_orig VARCHAR(45),
  v_password_new VARCHAR(45) )
RETURNS TEXT AS 
$func$
-- RETURNS message indicating successful login or failure
DECLARE
  msg TEXT := 'Password could not be updated.';
  updated BOOL = False;
BEGIN
  IF EXISTS(
    SELECT * 
    FROM Customer 
    WHERE email = username 
    AND password = v_password_orig) 
  THEN
    SELECT update_customer(username,NULL,NULL,NULL,NULL,v_password_new) INTO updated;
    IF updated THEN
      msg := 'Password has been updated.';
    END IF;
  ELSE
    msg := 'Username and password combination not found. Password not updated.';
  END IF;
RETURN msg;
END;
$func$ LANGUAGE plpgsql;

