class Score {
  final int playerID;
  final int gameID;
  final int pointsScored;

  Score({
    required this.playerID,
    required this.gameID,
    required this.pointsScored,
  });

  factory Score.fromSqfliteDatbase(Map<String, dynamic> data) {
    return Score(
      playerID: data['playerID'],
      gameID: data['gameID'],
      pointsScored: data['pointsScored'],
    );
  }

  // Add the copyWith method
  Score copyWith({
    int? playerID,
    int? gameID,
    int? pointsScored,
  }) {
    return Score(
      playerID: playerID ?? this.playerID,
      gameID: gameID ?? this.gameID,
      pointsScored: pointsScored ?? this.pointsScored,
    );
  }
}
