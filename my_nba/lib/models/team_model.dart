class Team{
final String teamID;
final String City;
final String homeCourt;
final String division;


Team(
    {required this.teamID,
     required this.City,
     required this.homeCourt,
    required this.division,
    });
    
    factory Team.fromSqfliteDatbase(Map<String, dynamic> data) {
      return Team(
        teamID: data['teamID'],
        City: data['City'],
        homeCourt: data['homecourt'],
        division: data['division'],
      );

    } 
    }