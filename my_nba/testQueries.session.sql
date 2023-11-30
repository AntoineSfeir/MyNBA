-- select * from teams;
-- select * from players;
-- select * from scores;
-- select * from games;


-- QUERY 1
-- See How much an individual player scores in all games they've played in
-- from scores and player

-- test Alex Wilson 22222
Select p.playerID, p.firstName, p.lastName, sum(s.pointsScored) as AllPointsScored
FROM players as p, scores as s
WHERE p.playerID = 22222
    and s.playerID = 22222
GROUP BY p.playerID, p.firstName, p.lastName;

-- select playerID, sum(pointsScored)
-- from scores
-- where playerID = 22222
-- group by playerID;


-- QUERY 2
-- See the list of players on a team.

-- test with Rockets, teamID is 1001
Select p.playerID, p.firstName, p.lastName, p.teamName
from players as p, teams as t
where p.teamName = 'Rockets'
    and t.teamName = 'Rockets';

-- -- OR

-- Select playerID, firstName, lastName, teamID
-- from players
-- where teamID = '1001';

-- QUERY 3
-- See the teams ranked by scores within a division.

-- test with Division 1
-- Select * from teams where division like '%1';

-- select div1.division, p.teamID, p.firstName, p.lastName, sum(s.pointsScored) as playerPoints
-- from players as p, scores as s, 
--     (Select * from teams where division like '%1') as div1
-- where div1.teamID = p.teamID
--     and p.playerID = s.playerID
-- ORDER by div1.division, p.teamID, p.firstName, p.lastName;

-- select * 
-- from players, (Select * from teams where division like '%1') as div1
-- where players.teamID = div1.teamID;

-- select * 
-- from players, (Select * from teams where division like '%2') as div1
-- where players.teamID = div1.teamID;

-- select teamID from teams;

-- counting all players on each team
-- select count(players.playerID), sub.teamID 
-- from players, (select distinct teamID from players) as sub
-- where sub.teamID = players.teamID
-- group by sub.teamID;