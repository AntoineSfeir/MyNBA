class Player {
  int playerID;
  String name;
  String team;
  int jerseyNumber;
  String position;
  String height;

  Player(
      {required this.playerID,
      required this.name,
      required this.jerseyNumber,
      required this.position,
      required this.team,
      required this.height});

  // Convert a Player object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'name': name,
      'jerseyNumber': jerseyNumber,
      'position': position,
      'team': team,
      'height': height
    };
  }

  // Create a Player object from a map received from the database
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerID: map['playerID'],
      name: map['name'],
      jerseyNumber: map['jerseyNumber'],
      position: map['position'],
      team: map['team'],
      height: map['height'],
    );
  }
}
