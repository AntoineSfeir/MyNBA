import 'package:flutter/material.dart';
import 'package:my_nba/data/score_db.dart';
import 'package:my_nba/data/player_db.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/pages/games_page/games_page.dart';
// ScoreEntryPage.dart

class ScoreEntryPage extends StatefulWidget {
  // You may need to pass relevant data to this page, such as player information.
  // For simplicity, I'll assume you're passing player names as a list.
  final int gameID;
  final String team1ID;
  final String team2ID;

  const ScoreEntryPage(
      {Key? key,
      required this.gameID,
      required this.team1ID,
      required this.team2ID})
      : super(key: key);

  @override
  _ScoreEntryPageState createState() => _ScoreEntryPageState();
}

class _ScoreEntryPageState extends State<ScoreEntryPage> {
  // Create controllers for each score input field
  List<TextEditingController> scoreControllers = [];

  Future<List<Player>>? homeTeamPlayers;
  Future<List<Player>>? awayTeamPlayers;

  PlayerDb playerDb = PlayerDb();
  ScoreDB scoreDB = ScoreDB();

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    fetchPlayer();
    _initializeControllers();
    // Initialize scoreControllers with an empty controller for each player
  }

  void fetchPlayer() {
    homeTeamPlayers = PlayerDb().fetchPlayerByTeam(widget.team1ID);
    awayTeamPlayers = PlayerDb().fetchPlayerByTeam(widget.team2ID);
  }

  void _initializeControllers() async {
    // Fetch players
    List<Player> allPlayers = [];

    final homePlayers = await homeTeamPlayers;
    final awayPlayers = await awayTeamPlayers;

    if (homePlayers != null) {
      allPlayers.addAll(homePlayers);
    }

    if (awayPlayers != null) {
      allPlayers.addAll(awayPlayers);
    }

    // Initialize scoreControllers with an empty controller for each player
    scoreControllers =
        List.generate(allPlayers.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Player>>(
                future: homeTeamPlayers,
                builder: (context, homeSnapshot) {
                  if (homeSnapshot.hasData) {
                    return FutureBuilder<List<Player>>(
                      future: awayTeamPlayers,
                      builder: (context, awaySnapshot) {
                        if (awaySnapshot.hasData) {
                          List<Player> allPlayers = [
                            ...homeSnapshot.data!,
                            ...awaySnapshot.data!
                          ];

                          return Container(
                            height: MediaQuery.of(context).size.height *
                                0.7, // Set a height limit
                            child: ListView.builder(
                              itemCount: allPlayers.length,
                              itemBuilder: (context, index) {
                                Player currentPlayer = allPlayers[index];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${currentPlayer.firstName} ${currentPlayer.lastName}'),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: scoreControllers[index],
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else if (awaySnapshot.hasError) {
                          return const Text('Error loading away team players');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else if (homeSnapshot.hasError) {
                    return const Text('Error loading home team players');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _saveScores();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamesPage(),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveScores() async {
    // Assuming that homeTeamPlayers and awayTeamPlayers are already fetched with player information
    List<Player> allPlayers = [];

    final homePlayers = await homeTeamPlayers;
    final awayPlayers = await awayTeamPlayers;
    if (homePlayers != null) {
      allPlayers.addAll(homePlayers);
    }

    if (awayPlayers != null) {
      allPlayers.addAll(awayPlayers);
    }
    for (int i = 0; i < allPlayers.length; i++) {
      int score = int.tryParse(scoreControllers[i].text) ?? 0;

      await scoreDB.insertScore(
          playerID: allPlayers[i].playerID, gameID:  widget.gameID, pointsScored: score);
    }
  }
}
