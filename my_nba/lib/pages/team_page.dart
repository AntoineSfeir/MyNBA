import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/data/database_helper.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
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

  void _generateRandomTeam() {
    Random random = Random();
    Team randomTeam = Team(
      teamID: 'RandomTeam${random.nextInt(100)}',
      city: 'RandomCity',
      homeCourt: 'RandomHomeCourt',
    );

    _databaseHelper.insertTeam(randomTeam).then((value) {
      _loadTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateRandomTeam,
            child: Text('Generate Random Team'),
          ),
          Expanded(
            child: _buildTeamList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList() {
    return ListView.builder(
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_teams[index].teamID),
          subtitle: Text('City: ${_teams[index].city} | Home Court: ${_teams[index].homeCourt}'),
        );
      },
    );
  }
}
