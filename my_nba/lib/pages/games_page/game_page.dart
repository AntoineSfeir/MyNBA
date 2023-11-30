import 'package:flutter/material.dart';
import 'package:my_nba/data/game_db.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/pages/games_page/games_page.dart';

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

  String homeTeam = "";
  String awayTeam = "";
  String court = "";
  String date = "";
  String time = "";

  GameDb db = GameDb();

  @override
  void initState() {
    super.initState();

    team1Controller = TextEditingController(text: widget.game.team1ID);
    team2Controller = TextEditingController(text: widget.game.team2ID);
    courtController = TextEditingController(text: widget.game.court);
    dateController = TextEditingController(text: widget.game.date);
    timeController = TextEditingController(text: widget.game.time);

    homeTeam = widget.game.team1ID;
    awayTeam = widget.game.team2ID;
    court = widget.game.court;
    date = widget.game.date;
    time = widget.game.time;
  }

  @override
  void dispose() {
    team1Controller.dispose();
    team2Controller.dispose();
    courtController.dispose();
    dateController.dispose();
    timeController.dispose();
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
          child: ListView(
            children: <Widget>[
              _buildDetailRow('Home:', homeTeam),
              _buildDetailRow('Away: ', awayTeam),
              _buildDetailRow('Court', court),
              _buildDetailRow('Date', date),
              _buildDetailRow('Time', time),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
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
    db.deleteGame(widget.game.gameID);
  }

  void _updateGameInformation() {

    setState(() {
      homeTeam = team1Controller.text;
      awayTeam = team2Controller.text;
      court = courtController.text;
      date = dateController.text;
      time = timeController.text;
    });
    db.updateGame(
      gameID: widget.game.gameID,
      team1ID: team1Controller.text,
      team2ID: team2Controller.text,
      court: courtController.text,
      date: dateController.text,
      time: timeController.text,
    );
  }
}
