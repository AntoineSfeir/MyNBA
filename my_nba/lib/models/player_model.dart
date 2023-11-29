class Player {
  final int playerID;
  final String firstName;
  final String lastName;
  final int height;
  final String teamID;
  final String position;
  final int jerseyNumber;

  Player(
      {required this.playerID,
      required this.firstName,
      required this.lastName,
      required this.height,
      required this.teamID,
      required this.position,
      required this.jerseyNumber});

  factory Player.fromSqfliteDatbase(Map<String, dynamic> data) {
    return Player(
      playerID: data['playerID'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      height: int.parse(data['height'].toString()), // Convert to int
      teamID: data['teamID'],
      position: data['position'],
      jerseyNumber: data['jerseyNumber'],
    );
  }
}
