import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "my_nba.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    // Create the 'player' table
    await db.execute('''
  CREATE TABLE player (
    playerID INTEGER PRIMARY KEY,
    name TEXT,
    jerseyNumber INTEGER,
    position TEXT,
    team TEXT,
    height TEXT
  )
''');

// Create the 'team' table
    await db.execute('''
  CREATE TABLE team (
    teamID TEXT PRIMARY KEY,
    city TEXT,
    homeCourt TEXT
  )
''');

    await db.execute('''
      CREATE TABLE game (
        id INTEGER PRIMARY KEY,
        team1Id INTEGER,
        team2Id INTEGER,
        date TEXT,
        location TEXT
      )
    ''');
  }

  // Insert a player into the database
  Future<int> insertPlayer(Player player) async {
    var dbClient = await db;
    return await dbClient.insert('player', player.toMap());
  }

  // Insert a team into the database
  Future<int> insertTeam(Team team) async {
    var dbClient = await db;
    return await dbClient.insert('team', team.toMap());
  }
// Update getPlayers, getTeams, and getGames methods

// Get all players from the database
  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .query('player', columns: ['playerID', 'name', 'jerseyNumber', 'position']);
    return maps.map((map) => Player.fromMap(map)).toList();
  }

// Get all teams from the database
  Future<List<Team>> getTeams() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query('team', columns: ['teamID', 'city', 'homeCourt']);
    return maps.map((map) => Team.fromMap(map)).toList();
  }

// Get all games from the database
  Future<List<Game>> getGames() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('game',
        columns: ['id', 'team1Id', 'team2Id', 'date', 'location']);
    return maps.map((map) => Game.fromMap(map)).toList();
  }

  // Close the database
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
