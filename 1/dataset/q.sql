 EXPLAIN ANALYZE
 CREATE TABLE t1 AS SELECT name FROM (SELECT Author.name, COUNT(foo.PaperId) FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'ieicet' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name) as temp WHERE temp.count > 9;
 CREATE TABLE t2 AS SELECT name FROM (SELECT Author.name FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'tcs' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name) AS temp;
 SELECT t1.name FROM t1 WHERE NOT EXISTS (SELECT t2.name FROM t2 WHERE t1.name = t2.name);
 DROP TABLE t1;
 DROP TABLE t2;