import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/data/database_helper.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Player> _players;

  @override
  void initState() {
    super.initState();
    _players = [];
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    List<Player> players = await _databaseHelper.getPlayers();
    setState(() {
      _players = players;
    });
  }

  void _generateRandomPlayer() {
    Random random = Random();
    Player randomPlayer = Player(
      playerID: random.nextInt(1000), // Adjust the range as needed
      name: 'Player${random.nextInt(100)}',
      jerseyNumber: random.nextInt(99) + 1, // Ensure jerseyNumber is between 1 and 99
      position: 'RandomPosition',
      team: 'RandomTeam',
      height: 'RandomHeight',
    );

    _databaseHelper.insertPlayer(randomPlayer).then((value) {
      _loadPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateRandomPlayer,
            child: Text('Generate Random Player'),
          ),
          Expanded(
            child: _buildPlayerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList() {
    return ListView.builder(
      itemCount: _players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_players[index].name),
          subtitle: Text('Jersey Number: ${_players[index].jerseyNumber} | Position: ${_players[index].position}'),
        );
      },
    );
  }
}
