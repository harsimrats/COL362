--PREAMBLE--

--1--
SELECT Venue.type, COUNT(Paper.PaperId)FROM Venue, Paper WHERE Venue.VenueId = Paper.VenueId GROUP BY Venue.type ORDER BY COUNT(Paper.PaperId) DESC, Venue.type;

--2--
SELECT AVG(count) as "the aggregate value" FROM (SELECT PaperId, COUNT(AuthorId) FROM PaperByAuthors GROUP BY PaperId) AS AuthorPerPaper;

--3--
SELECT DISTINCT Title AS "paper.Title" FROM Paper, (SELECT PaperId FROM (SELECT PaperId, COUNT(AuthorId) FROM PaperByAuthors GROUP BY PaperId) AS AuthorPerPaper WHERE count > 20) AS fo WHERE Paper.PaperId = fo.PaperId ORDER BY Title;

--4--
SELECT name AS "author.name" FROM Author WHERE NOT EXISTS (SELECT AuthorId FROM (SELECT DISTINCT AuthorId FROM PaperByAuthors, (SELECT PaperId, COUNT(AuthorId) FROM PaperByAuthors GROUP BY PaperId) AS AuthorPerPaper WHERE AuthorPerPaper.count = 1 AND PaperByAuthors.PaperId = AuthorPerPaper.PaperId) AS fo WHERE fo.AuthorId = Author.AuthorId) ORDER BY name;

--5--
SELECT name AS "author.name" FROM (SELECT name, COUNT(PaperId) FROM Author, PaperByAuthors WHERE Author.AuthorId = PaperByAuthors.AuthorId GROUP BY name ORDER BY count DESC, name) AS fo LIMIT 20;

--6--
SELECT name AS "author.name" FROM Author, (SELECT DISTINCT AuthorId FROM (SELECT PaperByAuthors.AuthorId, Count(fo.PaperId) FROM PaperByAuthors, (SELECT PaperId FROM (SELECT PaperId, COUNT(AuthorId) FROM PaperByAuthors GROUP BY PaperId) AS AuthorPerPaper WHERE count = 1) AS fo WHERE PaperByAuthors.PaperId = fo.PaperId GROUP BY AuthorId) AS foo WHERE foo.count > 50) AS fooo WHERE fooo.AuthorId = Author.AuthorId ORDER BY name;

--7--
SELECT name AS "author.name" FROM Author WHERE NOT EXISTS (SELECT AuthorId FROM (SELECT DISTINCT AuthorId FROM PaperByAuthors, (SELECT PaperId FROM Paper, (SELECT VenueId FROM Venue WHERE type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId) AS foo WHERE PaperByAuthors.PaperId = foo.PaperId) AS fooo WHERE fooo.AuthorId = Author.AuthorId) ORDER BY name;

--8--
SELECT name AS "author.name" FROM Author WHERE NOT EXISTS (SELECT AuthorId FROM (SELECT DISTINCT AuthorId FROM PaperByAuthors, (SELECT PaperId FROM Paper, (SELECT VenueId FROM Venue WHERE type != 'journals') AS fo WHERE Paper.VenueId = fo.VenueId) AS foo WHERE foo.PaperId = PaperByAuthors.PaperId) AS fooo WHERE fooo.AuthorId = Author.AuthorId) ORDER BY name;

--9--
SELECT name AS "author.name" FROM Author, (SELECT AuthorId FROM (SELECT PaperByAuthors.AuthorId, COUNT(Paper.PaperId) FROM PaperByAuthors, Paper WHERE Paper.year = 2012 AND PaperByAuthors.PaperId = Paper.PaperId GROUP BY PaperByAuthors.AuthorId HAVING COUNT(Paper.PaperId) > 1) AS fo INTERSECT SELECT AuthorId FROM (SELECT PaperByAuthors.AuthorId, COUNT(Paper.PaperId) FROM PaperByAuthors, Paper WHERE Paper.year = 2013 AND PaperByAuthors.PaperId = Paper.PaperId GROUP BY PaperByAuthors.AuthorId HAVING COUNT(Paper.PaperId) > 2) AS foo) AS fooo WHERE fooo.AuthorId = Author.AuthorId ORDER BY name;

--10--
SELECT name AS "author.name" FROM (SELECT Author.name, COUNT(foo.PaperId) FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'corr' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name ORDER BY count DESC, name) as temp LIMIT 20;

--11--
SELECT name AS "author.name" FROM (SELECT Author.name, COUNT(foo.PaperId) FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'amc' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name) as temp WHERE temp.count > 3 ORDER BY name;

--12--
SELECT t1.name FROM (SELECT name FROM (SELECT Author.name, COUNT(foo.PaperId) FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'ieicet' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name) as temp WHERE temp.count > 9) AS t1 WHERE NOT EXISTS (SELECT t2.name FROM (SELECT name FROM (SELECT Author.name FROM Author, (SELECT PaperByAuthors.AuthorId, Paper.PaperId FROM PaperByAuthors, Paper, (SELECT VenueId FROM Venue WHERE name = 'tcs' AND type = 'journals') AS fo WHERE fo.VenueId = Paper.VenueId AND PaperByAuthors.PaperId = Paper.PaperId) AS foo WHERE Author.AuthorId = foo.AuthorId GROUP BY Author.name) AS temp) AS t2 WHERE t1.name = t2.name);

--13--
SELECT year AS "Year", COUNT(*) AS "No. of Publication" FROM Paper WHERE year > 2003 AND year < 2014 GROUP BY year ORDER BY year;

--14--
SELECT COUNT(*) FROM (SELECT DISTINCT name FROM Author, (SELECT AuthorId FROM PaperByAuthors, (SELECT PaperId FROM Paper WHERE LOWER(Title) LIKE '%query%optimization%') AS fo WHERE fo.PaperId = PaperByAuthors.PaperId) AS foo WHERE foo.AuthorId = Author.AuthorId ORDER BY name) AS sh;

--15--
SELECT Title AS "paper.Title" FROM (SELECT Title, fo.count AS "paper.Title" FROM Paper, (SELECT Paper2Id, COUNT(Paper1Id) FROM Citation GROUP BY Paper2Id) AS fo WHERE Paper.PaperId = fo.Paper2Id ORDER BY fo.count, Title) AS temp;

--16--
SELECT Title AS "paper.Title" FROM Paper, (SELECT COUNT(Paper1Id), Paper2Id FROM Citation GROUP BY Paper2Id) AS fo WHERE Paper.PaperId = fo.Paper2Id AND fo.count > 10 ORDER BY Title;

--17--
SELECT Title AS "paper.Title" FROM Paper, (SELECT fo.Paper2Id FROM (SELECT Paper2Id, COUNT(Paper1Id) FROM Citation GROUP BY Paper2Id) AS fo, (SELECT Paper1Id, COUNT(Paper2Id) FROM Citation GROUP BY Paper1Id) AS foo WHERE foo.Paper1Id = fo.Paper2Id AND fo.count - foo.count > 9) AS fooo WHERE Paper.PaperId = fooo.Paper2Id ORDER BY Title;

--18--
SELECT DISTINCT Title AS "paper.Title" FROM Paper, (SELECT PaperId FROM Paper WHERE NOT EXISTS (SELECT Paper2Id FROM Citation WHERE Paper2Id = PaperId)) AS fo WHERE fo.PaperId = Paper.PaperId ORDER BY Title;

--19--
SELECT DISTINCT name AS "author.name" FROM Author, (SELECT fo.A1, AuthorId AS A2 FROM PaperByAuthors, (SELECT AuthorId AS A1, Paper2Id FROM Citation, PaperByAuthors WHERE Citation.Paper1Id = PaperByAuthors.PaperId AND Citation.Paper1Id != Citation.Paper2Id) AS fo WHERE fo.Paper2Id = PaperByAuthors.PaperId) AS foo WHERE foo.A1 = foo.A2 AND foo.A1 = Author.AuthorId ORDER BY name;

--20--
SELECT DISTINCT name FROM Author, (SELECT DISTINCT t1.AuthorId FROM (SELECT AuthorId FROM PaperByAuthors, (SELECT PaperId FROM Paper, (SELECT VenueId FROM Venue WHERE type = 'journals' AND name = 'corr') AS fo WHERE Paper.VenueId = fo.VenueId AND Paper.year > 2008 AND Paper.year < 2014) AS foo WHERE foo.PaperId = PaperByAuthors.PaperId) AS t1 WHERE NOT EXISTS (SELECT t2.AuthorId FROM (SELECT AuthorId FROM PaperByAuthors, (SELECT PaperId FROM Paper, (SELECT VenueId FROM Venue WHERE type = 'journals' AND name = 'ieicet') AS fo WHERE Paper.VenueId = fo.VenueId AND Paper.year = 2009) AS foo WHERE foo.PaperId = PaperByAuthors.PaperId) AS t2 WHERE t1.AuthorId = t2.AuthorId)) AS fo WHERE Author.AuthorId = fo.AuthorId ORDER BY name;

--21--


--22--
SELECT n AS "journal.name", y AS "journal.year" FROM ( SELECT fo.name AS n, year AS y, COUNT(PaperId) FROM Paper, (SELECT VenueId, name FROM Venue WHERE type = 'journals') AS fo WHERE Paper.VenueId = fo.VenueId GROUP BY fo.name, year) AS t1, (SELECT MAX(count) FROM (SELECT fo.name AS n, year AS y, COUNT(PaperId) FROM Paper, (SELECT VenueId, name FROM Venue WHERE type = 'journals') AS fo WHERE Paper.VenueId = fo.VenueId GROUP BY fo.name, year) AS t1) AS t2 WHERE count >= t2.MAX ORDER BY y, n;

--23--
SELECT t3.n AS "journal.name", name AS "author.name" FROM Author, (SELECT AuthorId, t1.n FROM (SELECT AuthorId, foo.name AS n, COUNT(foo.PaperId) FROM PaperByAuthors, (SELECT PaperId, fo.name FROM Paper, (SELECT VenueId, name FROM Venue WHERE type = 'journals') AS fo WHERE Paper.VenueId = fo.VenueId) AS foo WHERE foo.PaperId = PaperByAuthors.PaperId GROUP BY AuthorId, foo.name ORDER BY count DESC) AS t1, (SELECT n, MAX(count) FROM (SELECT AuthorId, foo.name AS n, COUNT(foo.PaperId) FROM PaperByAuthors, (SELECT PaperId, fo.name FROM Paper, (SELECT VenueId, name FROM Venue WHERE type = 'journals') AS fo WHERE Paper.VenueId = fo.VenueId) AS foo WHERE foo.PaperId = PaperByAuthors.PaperId GROUP BY AuthorId, foo.name ORDER BY count DESC) AS t1 GROUP BY n) AS t2 WHERE t2.n = t1.n AND t2.max = t1.count) AS t3 WHERE t3.AuthorId = Author.AuthorId ORDER BY t3.n, name;

--24--

--25--

--CLEANUP--