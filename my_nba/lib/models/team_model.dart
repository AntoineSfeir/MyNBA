class Team{
final String teamID;
final String city;
final String homecourt;
final String division;


Team(
    {required this.teamID,
     required this.city,
     required this.homecourt,
    required this.division,
    });
    
    factory Team.fromSqfliteDatbase(Map<String, dynamic> data) {
      return Team(
        teamID: data['teamID'],
        city: data['city'],
        homecourt: data['homecourt'],
        division: data['division'],
      );

    } 
    }