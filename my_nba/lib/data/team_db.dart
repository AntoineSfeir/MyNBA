import 'package:sqflite/sqflite.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/data/database_service.dart';

class TeamDb {
  final teamTableName = "teams";

  Future<void> createTeamTable(Database database) async {
    await database.execute('''
        CREATE TABLE teams (
          teamID INT PRIMARY KEY,
          teamName VARCHAR(50),
          city VARCHAR(50),
          homecourt VARCHAR(50),
          division VARCHAR(50)
        )
      ''');

    await database.execute('''
     INSERT INTO teams (teamID, teamName, city, homecourt, division)
      VALUES
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
   ''');
  }

  Future<int> insertTeam(
      {required teamID,
      required teamName,
      required city,
      required homecourt,
      required division}) async {
    final Database database = await DatabaseService().getDataBase();
    return await database.rawInsert(
        'INSERT INTO $teamTableName (teamID, teamName, city, homecourt, division) VALUES(?, ?, ?, ?, ?)',
        [
          teamID,
          teamName,
          city,
          homecourt,
          division,
        ]);
  }

  Future<List<Team>> fetchAllTeams() async {
    final Database database = await DatabaseService().getDataBase();

    final teams = await database.rawQuery('SELECT * FROM $teamTableName');
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
      required teamName,
      required city,
      required homecourt,
      required division}) async {
    final Database database = await DatabaseService().getDataBase();
 
    return await database.update(
        teamTableName,
        {
          'teamName': teamName,
          'city': city,
          'homecourt': homecourt,
          'division': division,
        },
        where: 'teamID = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [teamID]);
  }

  Future<int> deleteTeam(int teamID) async {
    final Database database = await DatabaseService().getDataBase();
    return await database
        .rawDelete('DELETE FROM $teamTableName WHERE teamID = ?', [teamID]);
  }
}
