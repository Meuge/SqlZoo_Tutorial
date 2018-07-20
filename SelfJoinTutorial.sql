/* 

SELF JOIN

Details of the database Looking at the data

stops(id, name)
route(num,company,pos, stop)


*/


--1-How many stops are in the database.


SELECT DISTINCT COUNT(name) AS 'Total Stops' FROM stops;


--2-Find the id value for the stop 'Craiglockhart'


SELECT id FROM stops where name = 'Craiglockhart';


--3-Give the id and the name for the stops on the '4' 'LRT' service.


SELECT stop, stops.name FROM route JOIN stops ON route.stop=stops.id  WHERE num=4 AND company ='LRT';


--4-The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*) as Routes
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num HAVING  COUNT(*)>=2;


--5-Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop,b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND  stopb.name='London Road';


--6-The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name= 'London Road';

--7-Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Haymarket' AND stopb.name= 'Leith';


--8-Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name= 'Tollcross';


--9-Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.


SELECT stopb.name, a.company, a.num FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND a.company = 'LRT' ;


--10-Find the routes involving two buses that can go from Craiglockhart to Sighthill.Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.



SELECT DISTINCT bus1.num, bus1.company, stops.name, bus2.num, bus2.company 
FROM ( SELECT start1.num, start1.company, r1.stop FROM route AS start1 
JOIN route AS r1 
ON start1.num = r1.num 
AND start1.company = r1.company AND start1.stop != r1.stop 
WHERE start1.stop = 
(SELECT id FROM stops WHERE name = 'Craiglockhart')) AS bus1 
JOIN (SELECT start2.num, start2.company, start2.stop 
FROM route AS start2 
JOIN route AS r2 
ON start2.num = r2.num AND start2.company = r2.company AND start2.stop != r2.stop 
WHERE r2.stop = (SELECT id FROM stops WHERE name = 'Sighthill')) AS bus2 
ON bus1.stop = bus2.stop 
JOIN stops ON bus1.stop = stops.id ;


