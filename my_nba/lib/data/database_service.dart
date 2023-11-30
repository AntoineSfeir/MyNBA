import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_nba/data/game_db.dart';
import 'package:my_nba/data/team_db.dart';
import 'package:my_nba/data/score_db.dart';
import 'package:my_nba/data/player_db.dart';
import 'package:my_nba/models/score_model.dart';

class DatabaseService {
  Database? _database;

  Future<Database> getDataBase() async {
    _database = await _initialize();
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initialize();
      return _database!;
    }
  }

  Future<String> getFullPath() async {
    const name = 'my_nba.db';
    const path = 'my_nba/lib/';
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await getFullPath();
    var database = await openDatabase(
      path,
      version: 2,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
      await PlayerDb().createPlayerTable(database);
      await TeamDb().createTeamTable(database);
      await GameDb().createGameTable(database);
      await ScoreDB().createScoreTable(database);
  }
}
