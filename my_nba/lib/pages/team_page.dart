import 'package:flutter/material.dart';
import 'package:my_nba/data/team_db.dart';
import 'package:my_nba/pages/teams_page.dart';
import 'package:my_nba/models/team_model.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key, required this.team});

  final Team team;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  late TextEditingController cityController;
  late TextEditingController homecourtController;
  late TextEditingController divisionController;
  late TextEditingController teamIdController;

  TeamDb db = TeamDb();

  String teamName = "";
  String city = '';
  String homecourt = '';
  String division = '';

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the team's current information
    teamIdController = TextEditingController(text: widget.team.teamID);
    cityController = TextEditingController(text: widget.team.city);
    homecourtController = TextEditingController(text: widget.team.homecourt);
    divisionController = TextEditingController(text: widget.team.division);

    // Initialize the team information
    teamName = widget.team.teamID;
    city = widget.team.city;
    homecourt = widget.team.homecourt;
    division = widget.team.division;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    teamIdController.dispose();
    cityController.dispose();
    homecourtController.dispose();
    divisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Team Details'),
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
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildDetailRow('Team Name', teamName),
            _buildDetailRow('City', widget.team.city),
            _buildDetailRow('Homecourt', widget.team.homecourt),
            _buildDetailRow('Division', widget.team.division),
          ],
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
          title: const Text('Edit Team Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Team Name', teamIdController),
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
                // Save updated team information
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }

  void _deleteTeam() {
    db.deleteTeam(widget.team.teamID);
  }

  void _updateTeamInformation() {
    // Save the updated team information
    setState(() {
      teamName = teamIdController.text;
      city = cityController.text;
      homecourt = homecourtController.text;
      division = divisionController.text;
    });

    db.updateTeam(
        teamID: teamName, city: city, homecourt: homecourt, division: division);
  }
}
