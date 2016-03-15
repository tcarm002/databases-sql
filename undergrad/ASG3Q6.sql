/* 6. How many book copies have a price that is greater than $20 and less than $25 ? */

Select COUNT (*) AS copies
From Copy
Where price > 20 AND price < 25;