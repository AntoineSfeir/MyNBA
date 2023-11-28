class Team {
  String teamID;
  String city;
  String homeCourt;
  String division;

  Team({
    required this.teamID,
    required this.city,
    required this.homeCourt,
    required this.division,
  });

  // Convert a Team object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'teamID': teamID,
      'city': city,
      'homeCourt': homeCourt,
      'division': division,
    };
  }

  // Create a Team object from a map received from the database
  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      teamID: map['teamID'],
      city: map['city'],
      homeCourt: map['homeCourt'],
      division: map['division'],
    );
  }
}
