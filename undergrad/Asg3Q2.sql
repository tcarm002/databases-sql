/* Query 2 -  List the title of each book that has the type PSY or whose publisher code is JP. You are allowed 
   to use only one condition term in any WHERE clause; i.e., don't use AND/OR boolean operations. */

  Select title 
  From book
  Where type='PSY'
UNION
  Select title 
  from book
  Where publishercode='JP';