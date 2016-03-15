/*4. List the title of each book written by John Steinbeck and that has the type FIC.*/

Select title
From Book
Where bookcode IN (Select bookcode
	From Wrote
	Where authornum=(Select authorNum
			From Author
Where authorLast='Steinbeck' AND authorFirst='John'))
AND
type='FIC'; 