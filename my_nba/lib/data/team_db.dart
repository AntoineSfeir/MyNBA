import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/data/database_service.dart';

class TeamDb {
  final teamTableName = "teams";

  Future<void> createTeamTable(Database database) async {
        await database.execute('''
        CREATE TABLE teams (
          teamID VARCHAR(50) PRIMARY KEY,
          city VARCHAR(50),
          homecourt VARCHAR(50),
          division VARCHAR(50)
        )
      ''');

    await database.execute('''
      INSERT INTO teams (teamID, city, homeCourt, division)VALUES
        ('Rockets', 'Houston', 'Rocket Arena', 'Division Gamma'),
        ('Dragons', 'Los Angeles', 'Dragon Court', 'Division Gamma'),
        ('Thunder', 'Oklahoma City', 'Thunder Dome', 'Division Gamma'),
        ('Tigers', 'Detroit', 'Tiger Stadium', 'Division Gamma'),
        ('Eagles', 'Philadelphia', 'Eagle Nest', 'Division Gamma'),
        ('Panthers', 'Miami', 'Panther Park', 'Division Alpha'),
        ('Spartans', 'New York', 'Spartan Coliseum', 'Division Alpha'),
        ('Blizzards', 'Denver', 'Blizzard Arena', 'Division Alpha'),
        ('Wolves', 'Minneapolis', 'Wolf Den', 'Division Alpha'),
        ('Phoenix', 'Phoenix', 'Phoenix Court', 'Division Alpha');
   ''');
  }

  Future<int> insertTeam(
      {required teamID,
      required city,
      required homecourt,
      required division}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
        'INSERT INTO $teamTableName (teamID, city, homecourt, division) VALUES(?, ?, ?, ?)',
        [
          teamID,
          city,
          homecourt,
          division,
        ]);
  }

  Future<List<Team>> fetchAllTeams() async {
    final Database database = await DatabaseService().getDataBase();

    final teams = await database.rawQuery('SELECT * FROM $teamTableName');
    print('Teams from database: $teams');
    return teams.map((team) => Team.fromSqfliteDatbase(team)).toList();
  }

  Future<Team> fetchTeamByID(String teamID) async {
    final Database database = await DatabaseService().getDataBase();
    final team = await database
        .rawQuery('SELECT * FROM $teamTableName WHERE teamID = ?', [teamID]);
    return Team.fromSqfliteDatbase(team.first);
  }

  Future<int> updateTeam(
      {required teamID,
      required city,
      required homecourt,
      required division}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.update(
        teamTableName,
        {
          'city': city,
          'homecourt': homecourt,
          'division': division,
        },
        where: 'teamID = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [teamID]);
  }

  Future<int> deleteTeam(String teamID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database
        .rawDelete('DELETE FROM $teamTableName WHERE teamID = ?', [teamID]);
  }
}
