import 'package:flutter/material.dart';
import 'package:my_nba/data/sql_console.dart';
import 'package:my_nba/pages/games_page/games_page.dart';
import 'package:my_nba/pages/team_pages/teams_page.dart';
import 'package:my_nba/pages/player_pages/players_page.dart';
import 'package:my_nba/data/database_service.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _queryController = TextEditingController();
  final SqlConsole _sqlConsole = SqlConsole();

  String _queryResult = '';
  bool _sqlSectionVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            restartDB(drops, creates, inits);
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.restart_alt_sharp,
            color: Colors.black,
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 450.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: const Text(
                    "My NBA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  background: Image.network(
                    "https://wallpapers.com/images/hd/golden-nba-finals-poster-4bh8i5ptqhb4m4h9.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Toggle SQL Console',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                      icon: _sqlSectionVisible
                          ? const Icon(Icons.keyboard_arrow_down)
                          : const Icon(Icons.keyboard_arrow_up),
                      onPressed: () {
                        setState(() {
                          _sqlSectionVisible = !_sqlSectionVisible;
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: _sqlSectionVisible,
                  child: _buildSqlSection(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home_rounded),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayersPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamsPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sports_basketball),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GamesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResizableTextField() {
    return TextField(
      controller: _queryController,
      maxLines: null, // Set maxLines to null for multiline support
      decoration: InputDecoration(
        labelText: 'SQL Console',
        filled: true,
        fillColor: Colors.grey[300],
        suffixIcon: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            setState(() {
              final List<String> queries = _queryController.text
                  .split(';')
                  .map((e) => e.trim())
                  .toList();
              final List<String> results = [];

              for (final String query in queries) {
                if (query.isNotEmpty) {
                  _sqlConsole.runQuery(query).then((value) {
                    results.add(value);
                    _queryResult = results.join('\n' + '-' * 40 + '\n');
                  });
                }
              }
            });
          },
        ),
      ),
      textInputAction: TextInputAction.newline,
      onEditingComplete: () {
        // Adjust the size of the text field when Enter is pressed
        _adjustTextFieldSize();
      },
    );
  }

  Widget _buildSqlSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResizableTextField(),
          const SizedBox(height: 16),
          const Text('Output',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _queryResult,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _adjustTextFieldSize() {
    // Implement the logic to adjust the size of the text field here
    // For example, increase the number of maxLines
    setState(() {
      _queryController.text += '\n'; // Add a new line
      _queryController.selection = TextSelection.collapsed(
        offset: _queryController.text.length,
      );
    });
  }

  Future<void> restartDB(String drops, String creates, String inits) async {
    final Database db = await DatabaseService().getDataBase();

    // await db.execute('');
    final Batch batch = db.batch();

    // Split the SQL statements by semicolon
    final List<String> dropers = drops.split(';');
    final List<String> creaters = creates.split(';');
    final List<String> initers = inits.split(';');

    for (final String statement in dropers) {
      final String trimmedStatement = statement.trim();
      if (trimmedStatement.isNotEmpty) {
        batch.execute(trimmedStatement);
      }
    }
    for (final String statement in creaters) {
      final String trimmedStatement = statement.trim();
      if (trimmedStatement.isNotEmpty) {
        batch.execute(trimmedStatement);
      }
    }
    for (final String statement in initers) {
      final String trimmedStatement = statement.trim();
      if (trimmedStatement.isNotEmpty) {
        batch.execute(trimmedStatement);
      }
    }
    // Commit the batch
    await batch.commit(noResult: true);
  }

  final String drops = '''DROP TABLE IF EXISTS players;
  DROP TABLE IF EXISTS teams;
  DROP TABLE IF EXISTS games;
  DROP TABLE IF EXISTS scores;''';

  final String creates = '''
      CREATE TABLE players (
        playerID INT PRIMARY KEY,
        firstName VARCHAR(50),
        lastName VARCHAR(50),
        height INT,
        teamName VARCHAR(50),
        position VARCHAR(50),
        jerseyNumber INT
    );
    CREATE TABLE teams (
        teamID INT PRIMARY KEY,
        teamName VARCHAR(50),
        city VARCHAR(50),
        homecourt VARCHAR(50),
        division VARCHAR(50)
    );

    CREATE TABLE games (
        gameID INT PRIMARY KEY,
        team1ID VARCHAR(50),
        team2ID VARCHAR(50),
        court VARCHAR(50),
        date TEXT,
        time TIME
    );

    CREATE TABLE scores (
        playerID INT,
        gameID INT,
        pointsScored INT,
        PRIMARY KEY (playerID, gameID),
        FOREIGN KEY (playerID) REFERENCES players(playerID),
        FOREIGN KEY (gameID) REFERENCES games(gameID)
    );
      ''';

  final String inits = '''
      INSERT INTO players (playerID, firstName, lastName, height, teamName, position, jerseyNumber) VALUES
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
        (33334, 'Ashley', 'Jones', 77, 'Tigers', 'Shooting Guard', 23),
        (33335, 'Jordan', 'Martinez', 79, 'Tigers', 'Small Forward', 44),
        (33336, 'Taylor', 'Thomas', 81, 'Tigers', 'Power Forward', 89),
        (33337, 'Ryan', 'Garcia', 80, 'Tigers', 'Center', 35),

        (44444, 'Cameron', 'Brown', 72, 'Blizzards', 'Point Guard', 24),
        (44445, 'Olivia', 'Clark', 74, 'Blizzards', 'Shooting Guard', 3),
        (44446, 'Dylan', 'Hernandez', 78, 'Blizzards', 'Small Forward', 45),
        (44447, 'Alexis', 'Young', 80, 'Blizzards', 'Power Forward', 33),
        (44448, 'Jordan', 'Scott', 84, 'Blizzards', 'Center', 56),

        (55555, 'Jackson', 'Smith', 72, 'Eagles', 'Point Guard', 40),
        (55556, 'Emma', 'Johnson', 76, 'Eagles', 'Shooting Guard', 68),
        (55557, 'Ethan', 'Harris', 78, 'Eagles', 'Small Forward', 42),
        (55558, 'Madison', 'Wilson', 81, 'Eagles', 'Power Forward', 16),
        (55559, 'Logan', 'Miller', 83, 'Eagles', 'Center', 99);


    INSERT INTO players (playerID, firstName, lastName, height, teamName, position, jerseyNumber) VALUES
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

        (88894, 'Logan', 'Garcia', 73, 'Phoenix', 'Point Guard', 15),
        (88895, 'Zoe', 'Wilson', 75, 'Phoenix', 'Shooting Guard', 19),
        (88896, 'Mason', 'Brown', 77, 'Phoenix', 'Small Forward', 5),
        (88897, 'Ava', 'Johnson', 80, 'Phoenix', 'Power Forward', 38),
        (88898, 'Noah', 'Smith', 82, 'Phoenix', 'Center', 10);


    INSERT INTO teams (teamID, teamName, city, homecourt, division) VALUES
        (1001, 'Rockets', 'Houston', 'Rocket Arena', 'Division Gamma'),
        (1002, 'Dragons', 'Los Angeles', 'Dragon Court', 'Division Gamma'),
        (1003, 'Thunder', 'Oklahoma City', 'Thunder Dome', 'Division Gamma'),
        (1004, 'Tigers', 'Detroit', 'Tiger Stadium', 'Division Gamma'),
        (1005, 'Eagles', 'Philadelphia', 'Eagle Nest', 'Division Gamma'),
        (1006, 'Panthers', 'Miami', 'Panther Park', 'Division Alpha'),
        (1007, 'Spartans', 'New York', 'Spartan Coliseum', 'Division Alpha'),
        (1008, 'Blizzards', 'Denver', 'Blizzard Arena', 'Division Alpha'),
        (1009, 'Wolves', 'Minneapolis', 'Wolf Den', 'Division Alpha'),
        (1010, 'Phoenix', 'Phoenix', 'Phoenix Court', 'Division Alpha');


    INSERT INTO games (gameID, team1ID, team2ID, court, date, time) VALUES
        (1111, 'Rockets', 'Panthers', 'Rocket Arena', '2023-03-15', '18:00'),
        (1112, 'Eagles', 'Blizzards', 'Eagle Nest', '2023-03-18', '19:30'),

        (2222, 'Tigers', 'Rockets', 'Tiger Stadium', '2023-03-20', '20:00'),
        (2223, 'Panthers', 'Eagles', 'Panther Park', '2023-03-23', '18:30'),

        (3333, 'Blizzards', 'Tigers', 'Blizzard Arena', '2023-03-25', '19:00'),
        (3334, 'Rockets', 'Eagles', 'Rocket Arena', '2023-03-28', '20:30');


    INSERT INTO games (gameID, team1ID, team2ID, court, date, time) VALUES
        (4444, 'Dragons', 'Thunder', 'Dragon Court', '2023-03-15', '18:30'),
        (4445, 'Phoenix', 'Wolves', 'Phoenix Court', '2023-03-18', '20:00'),

        (5555, 'Spartans', 'Dragons', 'Spartan Coliseum', '2023-03-20', '19:30'),
        (5556, 'Thunder', 'Phoenix', 'Thunder Dome', '2023-03-23', '18:00'),

        (6666, 'Wolves', 'Spartans', 'Wolf Den', '2023-03-25', '19:30'),
        (6667, 'Dragons', 'Phoenix', 'Dragon Court', '2023-03-28', '20:00');

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (11111, 1111, 12),	
        (11112, 1111, 18),
        (11113, 1111, 14),
        (11114, 1111, 20),
        (11115, 1111, 11),

        (11111, 2222, 30),	
        (11112, 2222, 27),
        (11113, 2222, 19),
        (11114, 2222, 30),
        (11115, 2222, 11),

        (11111, 3334, 24),	
        (11112, 3334, 11),
        (11113, 3334, 35),
        (11114, 3334, 29),
        (11115, 3334, 6); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (22222, 1111, 25),
        (22223, 1111, 22),
        (22224, 1111, 18),
        (22225, 1111, 20),
        (22226, 1111, 24),

        (22222, 2223, 32),
        (22223, 2223, 24),
        (22224, 2223, 23),
        (22225, 2223, 31),
        (22226, 2223, 32); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (55555, 1112, 12),  
        (55556, 1112, 11),
        (55557, 1112, 20),
        (55558, 1112, 18),
        (55559, 1112, 10),

        (55555, 2223, 16),  
        (55556, 2223, 12),
        (55557, 2223, 18),
        (55558, 2223, 23),
        (55559, 2223, 9),

        (55555, 3334, 13),  
        (55556, 3334, 11),
        (55557, 3334, 14),
        (55558, 3334, 12),
        (55559, 3334, 0);

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (44444, 1113, 33),
        (44445, 1113, 22),
        (44446, 1113, 31),
        (44447, 1113, 23),
        (44448, 1113, 24),

        (44444, 3333, 28),
        (44445, 3333, 29),
        (44446, 3333, 22),
        (44447, 3333, 33),
        (44448, 3333, 22); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (33333, 2222, 47),
        (33334, 2222, 50),
        (33335, 2222, 35),
        (33336, 2222, 85),
        (33337, 2222, 54),

        (33333, 3333, 46),
        (33334, 3333, 34),
        (33335, 3333, 45),
        (33336, 3333, 75),
        (33337, 3333, 43); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (66666, 6667, 33),
        (66667, 6667, 32),
        (66668, 6667, 28),
        (66669, 6667, 24),
        (66670, 6667, 26),

        (66666, 5555, 23),
        (66667, 5555, 20),
        (66668, 5555, 13),
        (66669, 5555, 31),
        (66670, 5555, 25),

        (66666, 4444, 22),
        (66667, 4444, 26),
        (66668, 4444, 28),
        (66669, 4444, 33),
        (66670, 4444, 15); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (77777, 4444, 6),
        (77778, 4444, 13),
        (77779, 4444, 19),
        (77780, 4444, 15),
        (77781, 4444, 25),

        (77777, 5556, 9),
        (77778, 5556, 16),
        (77779, 5556, 21),
        (77780, 5556, 8),
        (77781, 5556, 6); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (88894, 4445, 22),
        (88895, 4445, 24),
        (88896, 4445, 19),
        (88897, 4445, 26),
        (88898, 4445, 15),

        (88894, 5556, 29),
        (88895, 5556, 29),
        (88896, 5556, 25),
        (88897, 5556, 20),
        (88898, 5556, 18),  

        (88894, 6667, 25),
        (88895, 6667, 26),
        (88896, 6667, 27),
        (88897, 6667, 19),
        (88898, 6667, 12);  

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (99999, 4445, 26),
        (99998, 4445, 38),
        (99997, 4445, 28),
        (99996, 4445, 45),
        (99995, 4445, 43),

        (99999, 6666, 32),
        (99998, 6666, 20),
        (99997, 6666, 35),
        (99996, 6666, 39),
        (99995, 6666, 41); 

    INSERT INTO scores (playerID, gameID, pointsScored) VALUES
        (88888, 5555, 14), 
        (88889, 5555, 28), 
        (88890, 5555, 21), 
        (88891, 5555, 28), 
        (88892, 5555, 22), 

        (88888, 6666, 25), 
        (88889, 6666, 27), 
        (88890, 6666, 12), 
        (88891, 6666, 18), 
        (88892, 6666, 18); 
    ''';
}
