import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_nba/data/player_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> getDataBase() async {
    _database = await _initialize();
    if (_database != null) {
      print('Database is available');
      return _database!;
    } else {
      print('Database is not available');
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
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await PlayerDb().createPlayerTable(database);
}
