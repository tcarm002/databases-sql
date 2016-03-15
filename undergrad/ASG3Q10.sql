/*10.Ray Henry is considering increasing the price of all copies of fiction books whose quality is
   Excellent by 10%. To determine the new prices, list the bookcode, title, and increased price of
   every book in Excellent condition in the FictionCopies table. You are not allowed to modify the
   prices in the table, just show them.*/

Select bookcode, title, price*.10 + price AS increasedprice
From FictionCopies
Where quality='Excellent';