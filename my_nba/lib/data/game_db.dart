import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/data/database_service.dart';

class GameDb {
  final gameTableName = "games";

  Future<void> createGameTable(Database database) async {
    await database.execute('''
      CREATE TABLE games (
        gameID INT PRIMARY KEY,
        team1ID VARCHAR(50),
        team2ID VARCHAR(50),
        court VARCHAR(50),
        date TEXT,
        time TEXT
      );
      ''');

    await database.execute('''
      INSERT INTO games (gameID, team1ID, team2ID, court, date, time) VALUES
        (1111, 'Rockets', 'Panthers', 'Rocket Arena', '2023-03-15', '18:00'),
        (1112, 'Eagles', 'Blizzards', 'Eagle Nest', '2023-03-18', '19:30'),

        (2222, 'Tigers', 'Rockets', 'Tiger Stadium', '2023-03-20', '20:00'),
        (2223, 'Panthers', 'Eagles', 'Panther Park', '2023-03-23', '18:30'),

        (3333, 'Blizzards', 'Tigers', 'Blizzard Arena', '2023-03-25', '19:00'),
        (3334, 'Rockets', 'Eagles', 'Rocket Arena', '2023-03-28', '20:30');

        (4444, 'Dragons', 'Thunder', 'Dragon Court', '2023-03-15', '18:30'),
        (4445, 'Phoenix', 'Wolves', 'Phoenix Court', '2023-03-18', '20:00'),

        (5555, 'Spartans', 'Dragons', 'Spartan Coliseum', '2023-03-20', '19:30'),
        (5556, 'Thunder', 'Phoenix', 'Thunder Dome', '2023-03-23', '18:00'),

        (6666, 'Wolves', 'Spartans', 'Wolf Den', '2023-03-25', '19:30'),
        (6667, 'Dragons', 'Phoenix', 'Dragon Court', '2023-03-28', '20:00');
''');
  }

  Future<int> insertGame({
    required gameID,
    required team1ID,
    required team2ID,
    required court,
    required date,
    required time,
  }) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
      'INSERT INTO $gameTableName (gameID, team1ID, team2ID, court, date, time) VALUES (?, ?, ?, ?, ?, ?)',
      [gameID, team1ID, team2ID, court, date, time],
    );
  }

  Future<List<Game>> fetchAllGames() async {
    final Database database = await DatabaseService().getDataBase();
    final games = await database.rawQuery('SELECT * FROM $gameTableName');
    return games.map((game) => Game.fromSqfliteDatbase(game)).toList();
  }

  Future<Game> fetchGameByID(int gameID) async {
    final Database database = await DatabaseService().getDataBase();
    final game = await database
        .rawQuery('SELECT * FROM $gameTableName WHERE gameID = $gameID');
    return Game.fromSqfliteDatbase(game.first);
  }

  Future<List<Game>> fetchGamesByTeam(String teamID) async {
    final Database database = await DatabaseService().getDataBase();
    final games = await database.rawQuery(
        'SELECT * FROM $gameTableName WHERE team1ID = ? OR team2ID = ?',
        [teamID, teamID]);
    return games.map((game) => Game.fromSqfliteDatbase(game)).toList();
  }

  Future<int> updateGame({
    required int gameID,
    required String team1ID,
    required String team2ID,
    required String court,
    required String date,
    required String time,
  }) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.update(
      gameTableName,
      {
        'team1ID': team1ID,
        'team2ID': team2ID,
        'court': court,
        'date': date,
        'time': time,
      },
      where: 'gameID = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [gameID],
    );
  }

  Future<int> deleteGame(int gameID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database
        .rawDelete('DELETE FROM $gameTableName WHERE gameID = ?', [gameID]);
  }
}
