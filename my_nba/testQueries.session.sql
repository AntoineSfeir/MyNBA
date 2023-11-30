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


-- QUERY 2
-- See the list of players on a team.

-- test with Rockets
Select p.playerID, p.firstName, p.lastName, p.teamName
from players as p, teams as t
where p.teamName = 'Rockets'
    and t.teamName = 'Rockets';

-- -- OR

Select playerID, firstName, lastName, teamName
from players
where teamName = 'Rockets';

-- QUERY 3
-- See the teams ranked by scores within a division.

-- test with Division Alpha
Select division, teamName, sum(pointsScored) as totalTeamPoints
from (Select divA.division, p.playerID, p.teamName, sum(s.pointsScored) as pointsScored
    from (Select * from teams where division like '%Alpha') as divA, players as p, scores as s
    where divA.teamName = p.teamName
        and p.playerID = s.playerID
    group by divA.division, p.playerID, p.teamName) as sub
group by division, teamName
order by totalTeamPoints;


-- Q4 List all the players ranked by their total points.

select p.playerID, p.firstName, p.lastName, sum(s.pointsScored) as totalPointsScored
from players as p, scores as s
where p.playerID = s.playerID
group by p.playerID, p.firstName, p.lastName
order by totalPointsScored;


-- Q4 show the scores of each team in a certain game

--4444 game id
--- dragons and thunder

-- test with gameID 4444
select home.gameID, home.teamName as team1Name, home.team1Points, away.teamName as team2Name, away.team2Points
from (select team1.gameID, team1.teamName, sum(team1.pointsScored) as team1Points
        from (select t1.gameID as gameID, t1.teamName teamName, p.playerID as playerID, s.pointsScored as pointsScored
        from players as p, scores as s, (SELECT game.gameID, t.teamName
            from teams as t, (select * from games where gameID = 4444) as game
            where game.team1ID = t.teamName) as t1
        where p.teamName = t1.teamName
            and s.gameID = t1.gameID
            and s.playerID = p.playerID) as team1
        group by team1.gameID, team1.teamName) as home, 
    (select team2.gameID, team2.teamName, sum(team2.pointsScored) as team2Points
        from (select t2.gameID as gameID, t2.teamName teamName, p.playerID as playerID, s.pointsScored as pointsScored
        from players as p, scores as s, (SELECT game.gameID, t.teamName
            from teams as t, (select * from games where gameID = 4444) as game
            where game.team2ID = t.teamName) as t2
        where p.teamName = t2.teamName
            and s.gameID = t2.gameID
            and s.playerID = p.playerID) as team2
        group by team2.gameID, team2.teamName) as away;




-- Q6 BONUS see games played within specif dates
SELECT *
FROM games
WHERE date BETWEEN '2023-03-20' AND '2023-03-25'
order by date, time;