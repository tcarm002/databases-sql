/* 7. For each publisher, list the publisher name and the number of books published by it, only if 
   the publisher publishes at least 2 books. */

Select publishername,COUNT (*) as numpublished
From Book natural join Publisher
Group by publishername
Having COUNT(*) >1;