class Team {
  String teamID;
  String city;
  String homeCourt;

  Team({required this.teamID, required this.city, required this.homeCourt});

  // Convert a Team object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'teamID': teamID,
      'city': city,
      'homeCourt': homeCourt,
    };
  }

  // Create a Team object from a map received from the database
  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      teamID: map['name'],
      city: map['city'],
      homeCourt: map['homeCourt'],
    );
  }
}
