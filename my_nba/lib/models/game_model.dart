class Game{
  final int gameID;
  final String team1ID;
  final String team2ID;
  final String court;
  final DateTime date;
  final DateTime time;

  Game(
      {required this.gameID,
      required this.team1ID,
      required this.team2ID,
      required this.court,
      required this.date,
      required this.time,
      });

      factory Game.fromSqfliteDatbase(Map<String, dynamic> data) {
        return Game(gameID: data[''], 
          team1ID: data[''], 
          team2ID: data[''], 
          court: data[''], 
          date: data[''], 
          time: data['']);
      }
}
