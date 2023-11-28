class Team {
  int id;
  String name;
  String city;
  String abbreviation;

  Team({required this.id, required this.name, required this.city, required this.abbreviation});

  // Convert a Team object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'abbreviation': abbreviation,
    };
  }

  // Create a Team object from a map received from the database
  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      abbreviation: map['abbreviation'],
    );
  }
}
