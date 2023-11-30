import 'package:flutter/material.dart';
import 'package:my_nba/data/game_db.dart';
import 'package:my_nba/data/score_db.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/models/score_model.dart';
import 'package:my_nba/pages/games_page/games_page.dart';
import 'package:my_nba/data/player_db.dart'; // Replace with your actual import
import 'package:my_nba/models/player_model.dart'; // Replace with your actual import

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late TextEditingController team1Controller;
  late TextEditingController team2Controller;
  late TextEditingController courtController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController scoreController;

  String homeTeam = "";
  String awayTeam = "";
  String court = "";
  String date = "";
  String time = "";

  GameDb gameDB = GameDb();
  PlayerDb playerDB = PlayerDb();
  ScoreDB scoreDB = ScoreDB();

  Future<List<Player>>? homeTeamPlayers;
  Future<List<Player>>? awayTeamPlayers;

  Future<Score>? playerScores;

  Future<int>? homeTeamTotalPoints;
  Future<int>? awayTeamTotalPoints;
  int score = 0;

  @override
  void initState() {
    super.initState();

    team1Controller = TextEditingController(text: widget.game.team1ID);
    team2Controller = TextEditingController(text: widget.game.team2ID);
    courtController = TextEditingController(text: widget.game.court);
    dateController = TextEditingController(text: widget.game.date);
    timeController = TextEditingController(text: widget.game.time);
    scoreController = TextEditingController();

    homeTeam = widget.game.team1ID;
    awayTeam = widget.game.team2ID;
    court = widget.game.court;
    date = widget.game.date;
    time = widget.game.time;
    fetchTeamPlayers();
    fetchTeamTotalPoints();
  }

  void fetchTeamPlayers() {
    setState(() {
      homeTeamPlayers = playerDB.fetchPlayerByTeam(widget.game.team1ID);
      awayTeamPlayers = playerDB.fetchPlayerByTeam(widget.game.team2ID);
    });
  }

  void fetchTeamTotalPoints() {
    setState(() {
      homeTeamTotalPoints = calculateTeamTotalPoints(homeTeamPlayers);
      awayTeamTotalPoints = calculateTeamTotalPoints(awayTeamPlayers);
    });
  }

  Future<int> calculateTeamTotalPoints(Future<List<Player>>? players) async {
    List<Player> teamPlayers = await players!;
    int totalPoints = 0;

    for (Player player in teamPlayers) {
      Score? playerScore = await fetchScorePlayers(player.playerID);
      if (playerScore != null) {
        totalPoints += playerScore.pointsScored;
      }
    }

    return totalPoints;
  }

  @override
  void dispose() {
    team1Controller.dispose();
    team2Controller.dispose();
    courtController.dispose();
    dateController.dispose();
    timeController.dispose();
    scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Game Details',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GamesPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                _showEditDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildDetailRow('Home:', homeTeam),
                    const Divider(),
                    _buildPlayerList(homeTeam, homeTeamPlayers),
                    const Divider(),
                    _buildTotalScoreRow('Total Points:', homeTeamTotalPoints),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildDetailRow('Away: ', awayTeam),
                    const Divider(),
                    _buildPlayerList(awayTeam, awayTeamPlayers),
                    const Divider(),
                    _buildTotalScoreRow('Total Points:', awayTeamTotalPoints),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 1, // Adjust the flex factor as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildDetailRow('Court: ', court),
                    _buildDetailRow('Date: ', date),
                    _buildDetailRow('Time: ', time),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalScoreRow(String label, Future<int>? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<int>(
        future: value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...'); // or a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Points: ${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList(String teamID, Future<List<Player>>? players) {
    return FutureBuilder<List<Player>>(
      future: players,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No players available.');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: snapshot.data!.map((player) {
              return _buildPlayerItem(player);
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildPlayerItem(Player player) {
    return FutureBuilder<Score?>(
      future: fetchScorePlayers(player.playerID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          Score? playerScore = snapshot.data;

          score = playerScore!.pointsScored;
          return ListTile(
            title: Text('${player.firstName} ${player.lastName}'),
            subtitle: Text(
              'Position: ${player.position}, Jersey Number: ${player.jerseyNumber}, Score: ${score}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditScoreDialog(context, player, playerScore);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Score?> fetchScorePlayers(int playerID) async {
    Score scores = await scoreDB.fetchScoreByIDs(playerID, widget.game.gameID);
    return scores;
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Game Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Team 1', team1Controller),
                _buildTextField('Team 2', team2Controller),
                _buildTextField('Court', courtController),
                _buildTextField('Date', dateController),
                _buildTextField('Time', timeController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteGame();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GamesPage()),
                );
              },
              child: const Text('Delete Game'),
            ),
            TextButton(
              onPressed: () {
                _updateGameInformation();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }

  void _deleteGame() {
    gameDB.deleteGame(widget.game.gameID);
  }

  void _updateGameInformation() {
    setState(() {
      homeTeam = team1Controller.text;
      awayTeam = team2Controller.text;
      court = courtController.text;
      date = dateController.text;
      time = timeController.text;
    });
    gameDB.updateGame(
      gameID: widget.game.gameID,
      team1ID: team1Controller.text,
      team2ID: team2Controller.text,
      court: courtController.text,
      date: dateController.text,
      time: timeController.text,
    );
  }

  void _showEditScoreDialog(
      BuildContext context, Player player, Score? playerScore) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Player Score'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Player: ${player.firstName} ${player.lastName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildTextField('New Score', scoreController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateScore(player.playerID);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateScore(int playerID) {
    setState(() {
      score = int.parse(scoreController.text);
    });
    scoreDB.updateScore(
      playerID: playerID,
      gameID: widget.game.gameID,
      pointsScored: int.parse(scoreController.text),
    );
    fetchTeamTotalPoints();
  }
}
