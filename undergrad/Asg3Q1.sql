/*Query 1 - List the title of each book published by Penguin USA. You are allowed to use only 1 table in 
   any FROM clause.*/

Select title
From Book
Where publisherCode=(Select publisherCode
From Publisher
Where publisherName='Penguin USA');