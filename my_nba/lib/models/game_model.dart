
class Game {
  int id;
  int team1Id;
  int team2Id;
  DateTime date;
  String location;

  Game({
    required this.id,
    required this.team1Id,
    required this.team2Id,
    required this.date,
    required this.location,
  });

  // Convert a Game object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1Id': team1Id,
      'team2Id': team2Id,
      'date': date.toIso8601String(), // Convert DateTime to a format suitable for storage
      'location': location,
    };
  }

  // Create a Game object from a map received from the database
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      team1Id: map['team1Id'],
      team2Id: map['team2Id'],
      date: DateTime.parse(map['date']),
      location: map['location'],
    );
  }
}
