import 'package:flutter/material.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/data/database_helper.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
      ),
      body: _buildPlayerList(),
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
