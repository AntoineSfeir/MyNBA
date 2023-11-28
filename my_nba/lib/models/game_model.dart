class Game {
  int gameID;
  int team1ID;
  int team2ID;
  DateTime date;
  String court;

  Game({
    required this.gameID,
    required this.team1ID,
    required this.team2ID,
    required this.date,
    required this.court,
  });

  // Convert a Game object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': gameID,
      'team1ID': team1ID,
      'team2ID': team2ID,
      'date': date
          .toIso8601String(), // Convert DateTime to a format suitable for storage
      'court': court,
    };
  }

  // Create a Game object from a map received from the database
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameID: map['id'],
      team1ID: map['team1ID'],
      team2ID: map['team2ID'],
      date: DateTime.parse(map['date']),
      court: map['court'],
    );
  }
}
