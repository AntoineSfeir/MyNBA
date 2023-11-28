class Score {
  int playerID;
  int gameID;
  int pointsScored;

  Score({
    required this.playerID,
    required this.gameID,
    required this.pointsScored,
  });

  // Convert a Score object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'gameID': gameID,
      'pointsScored': pointsScored,
    };
  }

  // Create a Score object from a map received from the database
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      playerID: map['playerID'],
      gameID: map['gameID'],
      pointsScored: map['pointsScored'],
    );
  }
}
