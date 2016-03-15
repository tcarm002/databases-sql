/*9. Create a new table named FictionCopies using the data in the bookCode, title, branchNum, copyNum,
   quality, and price columns for those books that have the type FIC. You should do this in two
   steps: 9A) Create the table, and 9B) populate it with the said data.*/

DROP TABLE IF EXISTS FictionCopies;


CREATE TABLE FictionCopies(
bookcode character(4) NOT NULL,
title character(40),
branchnum numeric(2,0) NOT NULL,
copynum numeric(2,0) NOT NULL,
quality character(20),
price numeric(8,2));

INSERT INTO FictionCopies(Select bookcode, title, branchnum,copynum,quality,price
				FROM Book natural join Copy
				Where type='FIC');

Select *
From FictionCopies;