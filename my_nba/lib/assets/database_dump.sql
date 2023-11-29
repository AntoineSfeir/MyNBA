CREATE TABLE players (
    playerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    height INT,
    teamID VARCHAR(50),
    position VARCHAR(50),
    jerseyNumber INT
);


INSERT INTO players (playerID, firstName, lastName, height, teamID, position, jerseyNumber) VALUES
    (11111, 'John', 'Doe', 75, 'Rockets', 'Point Guard', 43),
    (11112, 'Michael', 'Johnson', 79, 'Rockets', 'Shooting Guard', 12),
    (11113, 'Sarah', 'Williams', 81, 'Rockets', 'Small Forward', 33),
    (11114, 'Chris', 'Davis', 82, 'Rockets', 'Power Forward', 35),
    (11115, 'Emily', 'Brown', 74, 'Rockets', 'Center', 51),
    
    (22222, 'Alex', 'Wilson', 73, 'Panthers', 'Point Guard', 80),
    (22223, 'Jessica', 'Anderson', 76, 'Panthers', 'Shooting Guard', 1),
    (22224, 'Brandon', 'Miller', 78, 'Panthers', 'Small Forward', 78),
    (22225, 'Megan', 'Taylor', 80, 'Panthers', 'Power Forward', 64),
    (22226, 'David', 'White', 79, 'Panthers', 'Center', 98),

    (33333, 'Aaron', 'Smith', 75, 'Tigers', 'Point Guard', 34),
    (33334, 'Ashley', 'Jones', 77, 'Tigers', 'Shooting Guard', 89),
    (33335, 'Jordan', 'Martinez', 79, 'Tigers', 'Small Forward', 44),
    (33336, 'Taylor', 'Thomas', 81, 'Tigers', 'Power Forward', 23),
    (33337, 'Ryan', 'Garcia', 80, 'Tigers', 'Center', 35),

    (44444, 'Cameron', 'Brown', 72, 'Braves', 'Point Guard', 24),
    (44445, 'Olivia', 'Clark', 74, 'Braves', 'Shooting Guard', 1),
    (44446, 'Dylan', 'Hernandez', 78, 'Braves', 'Small Forward', 45),
    (44447, 'Alexis', 'Young', 80, 'Braves', 'Power Forward', 33),
    (44448, 'Jordan', 'Scott', 84, 'Braves', 'Center', 56),

    (55555, 'Jackson', 'Smith', 72, 'Magic', 'Point Guard', 40),
    (55556, 'Emma', 'Johnson', 76, 'Magic', 'Shooting Guard', 68),
    (55557, 'Ethan', 'Harris', 78, 'Magic', 'Small Forward', 42),
    (55558, 'Madison', 'Wilson', 81, 'Magic', 'Power Forward', 16),
    (55559, 'Logan', 'Miller', 83, 'Magic', 'Center', 99);


INSERT INTO players (playerID, firstName, lastName, height, teamID, position, jerseyNumber) VALUES
    (66666, 'Lucas', 'Brown', 72, 'Dragons', 'Point Guard', 53),
    (66667, 'Sophia', 'Garcia', 75, 'Dragons', 'Shooting Guard', 16),
    (66668, 'Isaac', 'Martinez', 77, 'Dragons', 'Small Forward', 12),
    (66669, 'Ava', 'Jackson', 78, 'Dragons', 'Power Forward', 8),
    (66670, 'Liam', 'White',  81, 'Dragons', 'Center', 29),

    (77777, 'Mason', 'Taylor', 72, 'Thunder', 'Point Guard', 8),
    (77778, 'Emma', 'Hernandez', 76, 'Thunder', 'Shooting Guard', 16),
    (77779, 'Elijah', 'Clark', 79, 'Thunder', 'Small Forward', 12),
    (77780, 'Avery', 'Williams', 80, 'Thunder', 'Power Forward', 45),
    (77781, 'Mia', 'Johnson', 85, 'Thunder', 'Center', 31),

    (88888, 'Daniel', 'Wilson', 72, 'Spartans', 'Point Guard', 52),
    (88889, 'Lily', 'Jones', 74, 'Spartans', 'Shooting Guard', 3),
    (88890, 'Owen', 'Garcia', 77, 'Spartans', 'Small Forward', 19),
    (88891, 'Grace', 'Anderson', 79, 'Spartans', 'Power Forward', 28),
    (88892, 'Carter', 'Brown', 85, 'Spartans', 'Center', 49),

    (99999, 'Evan', 'Smith', 76, 'Wolves', 'Point Guard', 15),
    (99998, 'Natalie', 'Miller', 78, 'Wolves', 'Shooting Guard', 35),
    (99997, 'Tyler', 'Taylor', 80, 'Wolves', 'Small Forward', 12),
    (99996, 'Alyssa', 'Harris', 82, 'Wolves', 'Power Forward', 38),
    (99995, 'Ella', 'Scott', 84, 'Wolves', 'Center', 39),

    (88894, 'Logan', 'Garcia', 73, '76ers', 'Point Guard', 45),
    (88895, 'Zoe', 'Wilson', 75, '76ers', 'Shooting Guard', 46),
    (88896, 'Mason', 'Brown', 77, '76ers', 'Small Forward', 47),
    (88897, 'Ava', 'Johnson', 80, '76ers', 'Power Forward', 48),
    (88898, 'Noah', 'Smith', 82, '76ers', 'Center', 49);

CREATE TABLE teams (
    teamID VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50),
    homeCourt VARCHAR(50),
    division VARCHAR(50)
);

INSERT INTO teams (teamID, city, homeCourt, division) VALUES
    ('Rockets', 'Houston', 'Rocket Arena', 'Division 1'),
    ('Dragons', 'Los Angeles', 'Dragon Court', 'Division 1'),
    ('Thunder', 'Oklahoma City', 'Thunder Dome', 'Division 1'),
    ('Tigers', 'Detroit', 'Tiger Stadium', 'Division 1'),
    ('Eagles', 'Philadelphia', 'Eagle Nest', 'Division 1');


INSERT INTO teams (teamID, city, homeCourt, division) VALUES
    ('Panthers', 'Miami', 'Panther Park', 'Division 2'),
    ('Spartans', 'New York', 'Spartan Coliseum', 'Division 2'),
    ('Blizzards', 'Denver', 'Blizzard Arena', 'Division 2'),
    ('Wolves', 'Minneapolis', 'Wolf Den', 'Division 2'),
    ('Phoenix', 'Phoenix', 'Phoenix Court', 'Division 2');

CREATE TABLE games (
    gameID INT PRIMARY KEY,
    team1ID VARCHAR(50),
    team2ID VARCHAR(50),
    court VARCHAR(50),
    date DATE,
    time TIME
);

-- Games for the Southern Division teams
INSERT INTO games (gameID, team1ID, team2ID, court, date, time) VALUES
    (1111, 'Rockets', 'Panthers', 'Rocket Arena', '2023-03-15', '18:00'),
    (1112, 'Magic', 'Braves', 'Magic Arena', '2023-03-18', '19:30'),

    (2222, 'Tigers', 'Rockets', 'Tiger Stadium', '2023-03-20', '20:00'),
    (2223, 'Panthers', 'Magic', 'Panther Park', '2023-03-23', '18:30'),

    (3333, 'Braves', 'Tigers', 'Brave Court', '2023-03-25', '19:00'),
    (3334, 'Rockets', 'Magic', 'Rocket Arena', '2023-03-28', '20:30');

-- Games for the Eastern Division teams
INSERT INTO games (gameID, team1ID, team2ID, court, date, time) VALUES
    (4444, 'Dragons', 'Thunder', 'Dragon Court', '2023-03-15', '18:30'),
    (4445, '76ers', 'Wolves', '76er Arena', '2023-03-18', '20:00'),

    (5555, 'Spartans', 'Dragons', 'Spartan Coliseum', '2023-03-20', '19:30'),
    (5556, 'Thunder', '76ers', 'Thunder Dome', '2023-03-23', '18:00'),

    (6666, 'Wolves', 'Spartans', 'Wolf Den', '2023-03-25', '19:30'),
    (6667, 'Dragons', '76ers', 'Dragon Court', '2023-03-28', '20:00');



CREATE TABLE scores (
    playerID INT,
    gameID INT,
    pointsScored INT,
    PRIMARY KEY (playerID, gameID),
    FOREIGN KEY (playerID) REFERENCES players(playerID),
    FOREIGN KEY (gameID) REFERENCES games(gameID)
);

-- Additional scores for each game
INSERT INTO scores (playerID, gameID, pointsScored) VALUES
    (11111, 1111, 12),
    (11112, 1111, 18),
    (11113, 1111, 14),
    (11114, 1111, 20),
    (11115, 1111, 16),

    (22222, 1112, 25),
    (22223, 1112, 22),
    (22224, 1112, 18),
    (22225, 1112, 20),
    (22226, 1112, 24),

    (33333, 2222, 18),
    (33334, 2222, 22),
    (33335, 2222, 14),
    (33336, 2222, 20),
    (33337, 2222, 16),

    (44444, 2223, 24),
    (44445, 2223, 20),
    (44446, 2223, 18),
    (44447, 2223, 22),
    (44448, 2223, 26),

    (55555, 3333, 20),
    (55555, 3334, 25),
    (55556, 3333, 18),
    (55556, 3334, 22),
    (55557, 3333, 15),
    (55557, 3334, 20),

    (66666, 4444, 22),
    (66666, 4445, 28),
    (66667, 4444, 20),
    (66667, 4445, 25),
    (66668, 4444, 15),
    (66668, 4445, 20);



