class Team{
final String teamID;
final String city;
final String homeCourt;
final String division;


Team(
    {required this.teamID,
     required this.city,
     required this.homeCourt,
    required this.division,
    });
    
    factory Team.fromSqfliteDatbase(Map<String, dynamic> data) {
      return Team(
        teamID: data['teamID'],
        city: data['city'],
        homeCourt: data['homecourt'],
        division: data['division'],
      );

    } 
    }