/* 8. For each book copy available at the Henry on the Hill branch whose quality is Excellent, list
   the book's title (sorted alphabetically) and author names (in the order listed on the cover). */

Select title, authorlast, authorfirst
From Book natural join Author natural join Wrote
Where  Author.authornum IN( Select authornum 
			    From Wrote
			    Where Wrote.bookcode IN (
				Select  bookcode
				From Book
				Where bookcode IN(
					Select bookcode
					From Copy
					Where branchnum=(
						Select branchnum
						From Branch
						Where branchname='Henry on the Hill') AND quality='Excellent')))
AND Book.bookcode IN (Select  bookcode
				From Book
				Where bookcode IN(
					Select bookcode
					From Copy
					Where branchnum=(
						Select branchnum
						From Branch
						Where branchname='Henry on the Hill') AND quality='Excellent'))
	
Order by title, Wrote.sequence;


	

