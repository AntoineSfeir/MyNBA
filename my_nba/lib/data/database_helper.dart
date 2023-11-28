import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as ffi;
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  // Cant use path_provider on Web
  // Future<Database> initDatabase() async {
  //   var documentsDirectory = await getApplicationDocumentsDirectory();

  //   var path = join(documentsDirectory.path, "my_nba.db");

  //   var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  //   return db;
  // }

  Future<Database> initDatabase() async {
    ffi.databaseFactoryFfiWeb;
    var db = await ffi.databaseFactoryFfiWeb.openDatabase('my_nba.db');

    int version = await db.getVersion();

    if (version == 0) {
      // The database is being created for the first time
      _onCreate(db, 1);
      // Set the version to 1
      await db.setVersion(1);
    }
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE players (
        playerID INTEGER PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        height INTEGER,
        teamID TEXT,
        position TEXT,
        jerseyNumber INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE teams (
        teamID TEXT PRIMARY KEY,
        city TEXT,
        homeCourt TEXT,
        division TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE games (
        gameID INTEGER PRIMARY KEY,
        team1ID TEXT,
        team2ID TEXT,
        court TEXT,
        date TEXT,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE scores (
        playerID INTEGER,
        gameID INTEGER,
        pointsScored INTEGER,
        PRIMARY KEY (playerID, gameID),
        FOREIGN KEY (playerID) REFERENCES players(playerID),
        FOREIGN KEY (gameID) REFERENCES games(gameID)
      )
    ''');
  }

  // Insert a player into the database
  Future<int> insertPlayer(Player player) async {
    var dbClient = await db;
    return await dbClient.insert('players', player.toMap());
  }

  // Insert a team into the database
  Future<int> insertTeam(Team team) async {
    var dbClient = await db;
    return await dbClient.insert('teams', team.toMap());
  }

  // Insert a game into the database
  Future<int> insertGame(Game game) async {
    var dbClient = await db;
    return await dbClient.insert('games', game.toMap());
  }

  // Get all players from the database
  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('players');
    return maps.map((map) => Player.fromMap(map)).toList();
  }

// Get all teams from the database
  Future<List<Team>> getTeams() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('teams');
    return maps.map((map) => Team.fromMap(map)).toList();
  }

// Get all games from the database
  Future<List<Game>> getGames() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('games');
    return maps.map((map) => Game.fromMap(map)).toList();
  }

  // Delete players from the database
  Future<int> deletePlayer(int playerID) async {
    var dbClient = await db;
    return await dbClient
        .delete('players', where: 'playerID = ?', whereArgs: [playerID]);
  }

  // Delete teams from the database
  Future<int> deleteTeam(String teamID) async {
    var dbClient = await db;
    return await dbClient
        .delete('teams', where: 'teamID = ?', whereArgs: [teamID]);
  }

  // Delete games from the database
  Future<int> deleteGame(int gameID) async {
    var dbClient = await db;
    return await dbClient
        .delete('games', where: 'gameID = ?', whereArgs: [gameID]);
  }

  // Update player
  Future<int> updatePlayer(Player player) async {
    var dbClient = await db;
    return await dbClient.update('players', player.toMap(),
        where: 'playerID = ?', whereArgs: [player.playerID]);
  }

  // Update team
  Future<int> updateTeam(Team team) async {
    var dbClient = await db;
    return await dbClient.update('teams', team.toMap(),
        where: 'teamID = ?', whereArgs: [team.teamID]);
  }

  // Update game
  Future<int> updateGame(Game game) async {
    var dbClient = await db;
    return await dbClient.update('games', game.toMap(),
        where: 'gameID = ?', whereArgs: [game.gameID]);
  }
}
