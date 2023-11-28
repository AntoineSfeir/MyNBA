class Player {
  int id;
  String name;
  int jerseyNumber;
  String position;

  Player({required this.id, required this.name, required this.jerseyNumber, required this.position});

  // Convert a Player object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jerseyNumber': jerseyNumber,
      'position': position,
    };
  }

  // Create a Player object from a map received from the database
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      jerseyNumber: map['jerseyNumber'],
      position: map['position'],
    );
  }
}
