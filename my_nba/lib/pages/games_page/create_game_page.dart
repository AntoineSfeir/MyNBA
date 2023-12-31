import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_nba/data/game_db.dart';
import 'package:my_nba/data/team_db.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/pages/games_page/score_entry_page.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({Key? key}) : super(key: key);

  @override
  State<CreateGamePage> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGamePage> {
  late TextEditingController team1IDController;
  late TextEditingController team2IDController;
  late TextEditingController dateController;
  late TextEditingController timeController;

  GameDb gameDb = GameDb();
  TeamDb teamDB = TeamDb();
  int gameID = Random().nextInt(10000);

  @override
  void initState() {
    super.initState();
    team1IDController = TextEditingController();
    team2IDController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
  }

  @override
  void dispose() {
    team1IDController.dispose();
    team2IDController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Game'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Add your back button functionality here
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: team1IDController,
                decoration: const InputDecoration(labelText: 'Home'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: team2IDController,
                decoration: const InputDecoration(labelText: 'Away'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(hintText: 'Date(YYYY-MM-DD)'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(hintText: 'Time(24 HH:MM)'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 50, // Set your desired width
                child: ElevatedButton(
                  onPressed: () {
                    _saveGame();
                  },
                  child: const Text('Add Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGame() async {
    try {
      Team thisHomeTeam = await teamDB.fetchTeamByName(team1IDController.text);
      Team thisAwayTeam = await teamDB.fetchTeamByName(team2IDController.text);

      String homeTeamName = thisHomeTeam.teamName;
      String awayTeamName = thisAwayTeam.teamName;

      if (homeTeamName.isEmpty || awayTeamName.isEmpty) {
        return;
      } else {
        gameDb.insertGame(
          gameID: gameID,
          team1ID: team1IDController.text,
          team2ID: team2IDController.text,
          court: thisHomeTeam.homecourt,
          date: dateController.text,
          time: timeController.text,
        );

        // Navigate to the next screen
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreEntryPage(
              gameID: gameID,
              team1ID: team1IDController.text,
              team2ID: team2IDController.text,
            ),
          ),
        );
      }
    } catch (e) {
      // Display an alert dialog if there's an issue with inserting the game
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Your input is invalid. Please check if the teams you entered exist!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
