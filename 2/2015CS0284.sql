--1--

(WITH RECURSIVE path AS (SELECT source, destination FROM TrainSchedule UNION SELECT TrainSchedule.source, path.destination FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source) SELECT DISTINCT destination AS "cities_reachable" FROM path WHERE source = 'Delhi' ORDER BY destination);

--2--

(WITH RECURSIVE path AS (SELECT source, destination, arrival_time, departure_time FROM TrainSchedule UNION SELECT TrainSchedule.source, path.destination, TrainSchedule.arrival_time, TrainSchedule.departure_time  FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source AND ((TrainSchedule.arrival_time - path.departure_time < '1:00:00' AND TrainSchedule.arrival_time - path.departure_time > '00:00:00') OR (TrainSchedule.arrival_time - path.departure_time >= '-24:00:00' AND TrainSchedule.arrival_time - path.departure_time <= '-23:00:00'))) SELECT DISTINCT destination FROM path WHERE source = 'Delhi' ORDER BY destination);

--3---

WITH RECURSIVE path AS (SELECT source, destination, arrival_time, departure_time, CAST(EXTRACT(EPOCH FROM arrival_time - departure_time) AS INT) AS ttime FROM TrainSchedule UNION SELECT TrainSchedule.source, path.destination, TrainSchedule.arrival_time, TrainSchedule.departure_time, path.ttime + MOD(CAST(EXTRACT(EPOCH FROM path.Departure_Time - TrainSchedule.Arrival_Time + CAST('24:00:00' as TIME)) AS INT), 86400) + CAST(EXTRACT(EPOCH FROM TrainSchedule.Arrival_Time - TrainSchedule.Departure_Time) AS INT) as ttime FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source) SELECT MIN(ttime) * INTERVAL '1 sec' AS "shortest_time" FROM Path WHERE source = 'Delhi' AND destination='Mumbai';

--4--

SELECT DISTINCT train_id FROM TrainSchedule WHERE NOT EXISTS (SELECT * FROM (WITH RECURSIVE path AS (SELECT train_id, source, destination FROM TrainSchedule UNION SELECT TrainSchedule.train_id, TrainSchedule.source, path.destination FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source) SELECT DISTINCT destination FROM path WHERE source = 'Delhi') AS foo WHERE foo.destination = TrainSchedule.source) AND source <> 'Delhi';

--5--

(WITH RECURSIVE path AS (SELECT source, destination, arrival_time, departure_time, arrival_time AS sa FROM TrainSchedule UNION SELECT TrainSchedule.source, path.destination, path.arrival_time, TrainSchedule.departure_time, TrainSchedule.arrival_time AS sa FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source AND TrainSchedule.arrival_time - TrainSchedule.departure_time <= path.sa - path.departure_time) SELECT source, destination FROM path GROUP BY source, destination ORDER BY source, destination);

--6--

WITH RECURSIVE path AS ((SELECT source, destination, arrival_time, departure_time, arrival_time AS sa FROM TrainSchedule UNION SELECT ts1.source, ts2.destination, ts2.arrival_time, ts1.departure_time, ts1.arrival_time AS sa FROM TrainSchedule AS ts1, TrainSchedule AS ts2 WHERE ts1.destination = ts2.source) UNION SELECT ts1.source, path.destination, path.arrival_time, ts1.departure_time, ts1.arrival_time AS sa FROM path, TrainSchedule AS ts1, TrainSchedule AS ts2 WHERE ts2.destination = path.source AND ts1.destination = ts2.source AND ts1.arrival_time - ts1.departure_time >= path.sa - path.departure_time) SELECT source, destination FROM path GROUP BY source, destination ORDER BY source, destination;

--7--

(SELECT source, destination FROM ((SELECT source FROM TrainSchedule) UNION (SELECT destination FROM TrainSchedule)) AS foo1, ((SELECT destination FROM TrainSchedule) UNION (SELECT source FROM TrainSchedule)) AS foo2 WHERE foo1.source != foo2.destination) EXCEPT (WITH RECURSIVE path AS (SELECT source, destination FROM TrainSchedule UNION SELECT TrainSchedule.source, path.destination FROM path, TrainSchedule WHERE TrainSchedule.destination = path.source) SELECT * FROM path ORDER BY source, destination);

--8--

(WITH RECURSIVE path AS (SELECT source, destination FROM (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo UNION ALL SELECT foo.source, path.destination FROM path, (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo WHERE foo.destination = path.source) SELECT count(*) AS "no_of_paths" FROM path WHERE source = 'Delhi' AND destination = 'Mumbai' GROUP BY source, destination ORDER BY destination);

--9--

SELECT DISTINCT destination AS "cities_havingexactly_onepath" FROM (WITH RECURSIVE path AS (SELECT source, destination FROM (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo UNION ALL SELECT foo.source, path.destination FROM path, (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo WHERE foo.destination = path.source) SELECT source, destination, count(*) AS c FROM path GROUP BY source, destination) AS temp WHERE source = 'Delhi' AND c = 1 ORDER BY destination;

--10--

WITH RECURSIVE path AS (SELECT source, destination FROM (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo UNION ALL SELECT foo.source, path.destination FROM path, (SELECT source, destination FROM TrainSchedule GROUP BY source, destination) AS foo WHERE foo.destination = path.source) SELECT (temp1.no_of_paths)*(temp2.no_of_paths) AS "count" FROM (SELECT count(*) AS "no_of_paths" FROM path WHERE source = 'Delhi' AND destination = 'Bhopal' GROUP BY source, destination) AS temp1, (SELECT count(*) AS "no_of_paths" FROM path WHERE source = 'Bhopal' AND destination = 'Hyderabad' GROUP BY source, destination) AS temp2;

--CLEANUP--