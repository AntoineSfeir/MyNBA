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
  List<TextEditingController> homeScoreControllers = [];
  List<TextEditingController> awayScoreControllers = [];

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
    List<Player> hPlayers = [];
    List<Player> wPlayers = [];

    final homePlayers = await homeTeamPlayers;
    final awayPlayers = await awayTeamPlayers;

    if (homePlayers != null) {
      hPlayers.addAll(homePlayers);
    }

    if (awayPlayers != null) {
      wPlayers.addAll(awayPlayers);
    }

    // Initialize scoreControllers with an empty controller for each player
    homeScoreControllers =
        List.generate(hPlayers.length, (_) => TextEditingController());
    awayScoreControllers =
        List.generate(wPlayers.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in homeScoreControllers) {
      controller.dispose();
    }
    for (var controller in awayScoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Score Entry',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Add your back button functionality here
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(widget.team1ID,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(widget.team2ID,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Player>>(
                  future: homeTeamPlayers,
                  builder: (context, homeSnapshot) {
                    if (homeSnapshot.hasData) {
                      return FutureBuilder<List<Player>>(
                        future: awayTeamPlayers,
                        builder: (context, awaySnapshot) {
                          if (awaySnapshot.hasData) {
                            List<Player> homePlayers = [...homeSnapshot.data!];
                            List<Player> awayPlayers = [...awaySnapshot.data!];
                            return SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.7, // Set a height limit
                              child: ListView.builder(
                                itemCount: homePlayers.length,
                                itemBuilder: (context, index) {
                                  Player homePlayer = homePlayers[index];
                                  Player awayPlayer = awayPlayers[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                              '${homePlayer.firstName} ${homePlayer.lastName}'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TextField(
                                                 decoration: const InputDecoration(hintText: 'Enter an Integer Value'),
                                            controller:
                                                homeScoreControllers[index],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                              '${awayPlayer.firstName} ${awayPlayer.lastName}'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TextField(
                                             decoration: const InputDecoration(hintText: 'Enter an Integer Value'),
                                            controller:
                                                awayScoreControllers[index],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else if (awaySnapshot.hasError) {
                            return const Text(
                                'Error loading away team players');
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
      ),
    );
  }

  void _saveScores() async {
    // Assuming that homeTeamPlayers and awayTeamPlayers are already fetched with player information
    List<Player> allPlayers = [];

    List<int> allScores = [];

    final homePlayers = await homeTeamPlayers;
    final awayPlayers = await awayTeamPlayers;
    if (homePlayers != null) {
      allPlayers.addAll(homePlayers);
    }

    if (awayPlayers != null) {
      allPlayers.addAll(awayPlayers);
    }

    for(int i = 0; i < homeScoreControllers.length; i++){
      int score = int.tryParse(homeScoreControllers[i].text) ?? 0;
      allScores.add(score);
    }

    for(int i = 0; i < awayScoreControllers.length; i++){
      int score = int.tryParse(awayScoreControllers[i].text) ?? 0;
      allScores.add(score);
    }


    for (int i = 0; i < allPlayers.length; i++) {
      int score = allScores[i];

      await scoreDB.insertScore(
          playerID: allPlayers[i].playerID,
          gameID: widget.gameID,
          pointsScored: score);
    }
  }
}
