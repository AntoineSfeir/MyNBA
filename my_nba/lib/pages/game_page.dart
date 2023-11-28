import 'package:flutter/material.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/data/database_helper.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Game> _games;

  @override
  void initState() {
    super.initState();
    _games = [];
    _loadGames();
  }

  Future<void> _loadGames() async {
    List<Game> games = await _databaseHelper.getGames();
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
      ),
      body: _buildGameList(),
    );
  }

  Widget _buildGameList() {
    return ListView.builder(
      itemCount: _games.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Game ${_games[index].id}'),
          subtitle: Text('Date: ${_games[index].date} | Location: ${_games[index].location}'),
        );
      },
    );
  }
}
