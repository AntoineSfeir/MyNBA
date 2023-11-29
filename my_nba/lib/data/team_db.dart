import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/data/database_service.dart';

class TeamDb {
  final teamTableName = "teams";

  Future<void> createTeamTable(Database database) async {
    await database.execute('''
      CREATE TABLE teams (
        teamID VARCHAR(50) PRIMARY KEY,
        City VARCHAR(50),
        homeCourt VARCHAR(50),
        division VARCHAR(50),
      )
      '''
  );

  await database.execute('''
    INSERT INTO teams (teamID, City, homecourt, division)VALUES
      ('Rockets', 'Houston', 'Rocket Arena', 'Division 1'),
      ('Dragons', 'Los Angeles', 'Dragon Court', 'Division 1'),
      ('Thunder', 'Oklahoma City', 'Thunder Dome', 'Division 1'),
      ('Tigers', 'Detroit', 'Tiger Stadium', 'Division 1'),
      ('Eagles', 'Philadelphia', 'Eagle Nest', 'Division 1'),

    ('Panthers', 'Miami', 'Panther Park', 'Division 2'),
    ('Spartans', 'New York', 'Spartan Coliseum', 'Division 2'),
    ('Blizzards', 'Denver', 'Blizzard Arena', 'Division 2'),
    ('Wolves', 'Minneapolis', 'Wolf Den', 'Division 2'),
    ('Phoenix', 'Phoenix', 'Phoenix Court', 'Division 2');
  ''');
  }

  Future<int> insertTeam(
      {required teamID,
      required City,
      required homecourt,
      required division}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
      'INSERT INTO $teamTableName (teamID, City, homecourt, division) VALUES(?, ?, ?, ?)',
      [
        teamID,
        City,
        homecourt,
        division,
      ]);
  }

  Future<List<Team>> fetchAllTeams() async {
    final Database database = await DatabaseService().getDataBase();
    final teams = await database.rawQuery('SELECT * FROM teams');
    print('Teams from database: $teams');
    return teams.map((team) => Team.fromSqfliteDatbase(team)).toList();
  }

  Future<Team> fetchTeamByID(String teamID) async {
    final Database database = await DatabaseService().getDataBase();
    final team = await database.rawQuery(
        'SELECT * FROM $teamTableName WHERE teamID = ?', [teamID]);
    return Team.fromSqfliteDatbase(team.first);
  }

  Future<int> updateTeam(
    {required teamID,
    required City,
    required homecourt,
    required division}) async {
      final Database database = await DatabaseService().getDataBase();
      return await database.update(
        teamTableName,
        {
          'City': City,
          'homecourt': homecourt,
          'division': division,
        },
        where: 'teamID = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [teamID]);
  }

  Future<int> deleteTeam(String teamID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawDelete(
      'DELETE FROM $teamTableName WHERE teamID = ?', [teamID]);
  }
}