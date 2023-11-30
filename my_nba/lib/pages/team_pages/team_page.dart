import 'package:flutter/material.dart';
import 'package:my_nba/data/team_db.dart';
import 'package:my_nba/data/player_db.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/pages/team_pages/teams_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key, required this.team});

  final Team team;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  late TextEditingController cityController;
  late TextEditingController homecourtController;
  late TextEditingController divisionController;
  late TextEditingController teamNameController;

  TeamDb teamsDb = TeamDb();
  PlayerDb playersDb = PlayerDb();
  Future<List<Player>>? teamPlayers;

  String teamName = "";
  String city = '';
  String homecourt = '';
  String division = '';

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the team's current information
    teamNameController = TextEditingController(text: widget.team.teamName);
    cityController = TextEditingController(text: widget.team.city);
    homecourtController = TextEditingController(text: widget.team.homecourt);
    divisionController = TextEditingController(text: widget.team.division);

    // Initialize the team information
    teamName = widget.team.teamName;
    city = widget.team.city;
    homecourt = widget.team.homecourt;
    division = widget.team.division;
    fetchTeamPlayers();
  }

  void fetchTeamPlayers() {
    setState(() {
      teamPlayers = playersDb.fetchPlayerByTeam(widget.team.teamName);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    teamNameController.dispose();
    cityController.dispose();
    homecourtController.dispose();
    divisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Team Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Team Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDetailRow('Team Name', teamName),
            _buildDetailRow('City', widget.team.city),
            _buildDetailRow('Homecourt', widget.team.homecourt),
            _buildDetailRow('Division', widget.team.division),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Players',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Player>>(
                future: teamPlayers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Player>? players = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: players?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                '${players?[index].firstName} ${players![index].lastName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jersey Number: ${players[index].jerseyNumber}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Position: ${players[index].position}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'Height: ${players[index].height}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          title: const Text('Edit Team Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Team Name', teamNameController),
                _buildTextField('City', cityController),
                _buildTextField('Homecourt', homecourtController),
                _buildTextField('Division', divisionController),
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
                _deleteTeam();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamsPage()),
                );
              },
              child: const Text('Delete Team'),
            ),
            TextButton(
              onPressed: () {
                _updateTeamInformation();
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }

  void _deleteTeam() {
    teamsDb.deleteTeam(widget.team.teamID);
  }

  void _updateTeamInformation() {
    setState(() {
      teamName = teamNameController.text;
      city = cityController.text;
      homecourt = homecourtController.text;
      division = divisionController.text;
    });

    teamsDb.updateTeam(
      teamID: widget.team.teamID,
      teamName: teamName,
      city: city,
      homecourt: homecourt,
      division: division,
    );
  }
}
