import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/data/database_service.dart';

class PlayerDb {
  final playerTableName = "players";

  Future<void> createPlayerTable(Database database) async {
    await database.execute('''
      CREATE TABLE players (
        playerID INT PRIMARY KEY,
        firstName VARCHAR(50),
        lastName VARCHAR(50),
        height INT,
        teamID VARCHAR(50),
        position VARCHAR(50),
        jerseyNumber INT
      )
    ''');

    await database.execute('''
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
        (55559, 'Logan', 'Miller', 83, 'Magic', 'Center', 99),

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
    ''');
  }

  Future<int> insertPlayer(
      {required playerID,
      required firstName,
      required lastName,
      required height,
      required teamID,
      required position,
      required jerseyNumber}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
        'INSERT INTO $playerTableName (playerID, firstName, lastName, height, teamID, position, jerseyNumber) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          playerID,
          firstName,
          lastName,
          height,
          teamID,
          position,
          jerseyNumber
        ]);
  }

  Future<List<Player>> fetchAllPlayers() async {
    final Database database = await DatabaseService().getDataBase();
    final players = await database.rawQuery('SELECT * FROM players');
    return players.map((player) => Player.fromSqfliteDatbase(player)).toList();
  }

  Future<Player> fetchPlayerByID(int playerID) async {
    final Database database = await DatabaseService().getDataBase();
    final player = await database
        .rawQuery('SELECT * FROM $playerTableName WHERE playerID = $playerID');
    return Player.fromSqfliteDatbase(player.first);
  }

  Future<int> updatePlayer(
      {required playerID,
      required firstName,
      required lastName,
      required height,
      required teamID,
      required position,
      required jerseyNumber}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.update(
        playerTableName,
        {
          'firstName': firstName,
          'lastName': lastName,
          'height': height,
          'teamID': teamID,
          'position': position,
          'jerseyNumber': jerseyNumber
        },
        where: 'playerID = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [playerID]);
  }

  Future<int> deletePlayer(int playerID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawDelete(
        'DELETE FROM $playerTableName WHERE playerID = ?', [playerID]);
  }
}
