/*5. For each book, list the title (sorted alphabetically), publisher code, type and author names 
   (in the order listed on the cover).
*/
   Select title,publishercode, type, authorlast, authorfirst
   From Book,Author, Wrote
   Where Book.bookcode=Wrote.bookcode

AND
Wrote.authornum =Author.authornum
Order By title, sequence;
