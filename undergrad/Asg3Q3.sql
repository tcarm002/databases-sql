/*Query 3. List the title of each book that has the type CMP, HIS, or SCI. You are allowed to use only
   one condition term in any WHERE clause.*/

   Select title 
   From Book
   Where type='CMP'
   UNION
   Select title
   From Book
   Where type='HIS'
   UNION
   Select title 
   From Book
   Where type='SCI';