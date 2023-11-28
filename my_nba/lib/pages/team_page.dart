import 'package:flutter/material.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/data/database_helper.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Team> _teams;

  @override
  void initState() {
    super.initState();
    _teams = [];
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    List<Team> teams = await _databaseHelper.getTeams();
    setState(() {
      _teams = teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: _buildTeamList(),
    );
  }

  Widget _buildTeamList() {
    return ListView.builder(
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_teams[index].name),
          subtitle: Text('City: ${_teams[index].city} | Abbreviation: ${_teams[index].abbreviation}'),
        );
      },
    );
  }
}
