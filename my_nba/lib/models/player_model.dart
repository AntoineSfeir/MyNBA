class Player {
  int playerID;
  String firstName;
  String lastName;
  int height;
  String teamID;
  String position;
  int jerseyNumber;

  Player({
    required this.playerID,
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.teamID,
    required this.position,
    required this.jerseyNumber,
  });

  // Convert a Player object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'teamID': teamID,
      'position': position,
      'jerseyNumber': jerseyNumber,
    };
  }

  // Create a Player object from a map received from the database
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerID: map['playerID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      height: map['height'],
      teamID: map['teamID'],
      position: map['position'],
      jerseyNumber: map['jerseyNumber'],
    );
  }
}
