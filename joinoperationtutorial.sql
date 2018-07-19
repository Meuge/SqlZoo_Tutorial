/*

game
id	mdate	stadium	team1	team2
1001	8 June 2012	National Stadium, Warsaw	POL	GRE
1002	8 June 2012	Stadion Miejski (Wroclaw)	RUS	CZE
1003	12 June 2012	Stadion Miejski (Wroclaw)	GRE	CZE
1004	12 June 2012	National Stadium, Warsaw	POL	RUS
...

goal
matchid	teamid	player	gtime
1001	POL	Robert Lewandowski	17
1001	GRE	Dimitris Salpingidis	51
1002	RUS	Alan Dzagoev	15
1002	RUS	Roman Pavlyuchenko	82
...

eteam
id	teamname	coach
POL	Poland	Franciszek Smuda
RUS	Russia	Dick Advocaat
CZE	Czech Republic	Michal Bilek
GRE	Greece	Fernando Santos
...

*/

--1- Show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT goal.matchid, goal.player FROM goal 
  WHERE teamid='GER';
  
--2 - Show id, stadium, team1, team2 for just game 1012  

SELECT  game.id, game.stadium, game.team1, game.team2 FROM game WHERE id=1012;

--3-Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT goal.player,goal.teamid,game.stadium,game.mdate 
  FROM game JOIN goal ON (game.id=goal.matchid) WHERE goal.teamid='GER';
  
--4- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'  

SELECT game.team1,game.team2,goal.player FROM game JOIN goal ON (game.id=goal.matchid) WHERE goal.player LIKE 'Mario%';

--5-Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT goal.player, goal.teamid, eteam.coach,goal.gtime
  FROM goal JOIN eteam ON goal.teamid=game.id
 WHERE goal.gtime<=10;
 
 --6-List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
 
 SELECT game.mdate , eteam.teamname FROM game JOIN eteam ON game.team1=eteam.id WHERE eteam.coach = 'Fernando Santos';
 
 --7-List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
 
 SELECT goal.player FROM game JOIN goal ON  game.id=goal.matchid WHERE game.stadium= 'National Stadium, Warsaw';
 
 --8-Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT goal.player
  FROM game JOIN goal ON goal.matchid = game.id 
    WHERE (game.team1='GER' OR game.team2='GER') AND goal.teamid<>'GER';

--9-Show teamname and the total number of goals scored.

SELECT eteam.teamname, COUNT(eteam.teamname) AS GOALS
  FROM eteam JOIN goal ON eteam.id=goal.teamid 
 GROUP BY teamname;
 
 --10-Show the stadium and the number of goals scored in each stadium.
 
 SELECT game.stadium, COUNT(goal.matchid) AS GOALS
  FROM game JOIN goal ON game.id=goal.matchid
 GROUP BY game.stadium;
 
 --11-For every match involving 'POL', show the matchid, date and the number of goals scored.
 
 SELECT game.id, game.mdate, COUNT(goal.matchid) AS GOALS  FROM game JOIN goal ON goal.matchid = game.id WHERE (game.team1 = 'POL' OR game.team2 = 'POL') GROUP BY game.id , game.mdate;
 
 --12-For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
 
 SELECT game.id,game.mdate, COUNT(goal.matchid) AS GOALS FROM game JOIN goal on goal.matchid=game.id WHERE (game.team1 = 'GER' OR game.team2 = 'GER') AND goal.teamid='GER'  GROUP BY game.id,game.mdate;
 
 /*
 List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.

*/

SELECT game.mdate , game.team1, SUM(CASE WHEN goal.teamid=game.team1 THEN 1 ELSE 0  END) AS score1, game.team2,
SUM(CASE WHEN goal.teamid=game.team2 THEN 1 ELSE 0  END) AS score2 FROM
game LEFT JOIN goal ON (game.id = goal.matchid)
GROUP BY mdate,team1,team2
ORDER BY mdate, matchid, team1, team2;

-- You have to use to left join to list the matches where no team has score
