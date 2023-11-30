import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/score_model.dart';
import 'package:my_nba/data/database_service.dart';

class ScoreDb {
  final scoreTableName = "scores";

  Future<void> createScoreTable(Database database) async {
    await database.execute('''
      CREATE TABLE scores (
        playerID INT,
        gameID INT,
        pointsScored INT,
        PRIMARY KEY (playerID, gameID),
        FOREIGN KEY (playerID) REFERENCES players(playerID),
        FOREIGN KEY (gameID) REFERENCES games(gameID)
      )
    ''');

    await database.execute('''
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
    ''');
  }

  Future<int> insertScore(
      {required playerID, required gameID, required pointsScored}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
        'INSERT INTO $scoreTableName (playerID, gameID, pointsScored) VALUES (?, ?, ?)',
        [playerID, gameID, pointsScored]);
  }

  Future<List<Score>> fetchAllScores() async {
    final Database database = await DatabaseService().getDataBase();
    final scores = await database.rawQuery('SELECT * FROM scores');
    return scores.map((score) => Score.fromSqfliteDatbase(score)).toList();
  }

  Future<Score> fetchScoreByIDs(int playerID, gameID) async {
    final Database database = await DatabaseService().getDataBase();
    final score = await database.rawQuery(
        'SELECT * FROM $scoreTableName WHERE playerID = $playerID and gameID = $gameID');
    return Score.fromSqfliteDatbase(score.first);
  }

  Future<int> updateScore(
      {required playerID, required gameID, required pointsScored}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.update(scoreTableName, {'pointsScored': pointsScored},
        where: 'playerID = ? and gameID = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [playerID, gameID]);
  }

  Future<int> deleteScore(int playerID, int gameID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawDelete(
        'DELETE FROM $scoreTableName WHERE playerID = ? and gameID = ?',
        [playerID, gameID]);
  }
}
