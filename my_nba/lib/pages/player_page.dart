import 'package:flutter/material.dart';
import 'package:my_nba/data/player_db.dart';
import 'package:my_nba/pages/players_page.dart';
import 'package:my_nba/models/player_model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController teamController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController jerseyNumberController = TextEditingController();
  PlayerDb db = PlayerDb();

  String _firstName = '';
  String _lastName = '';
  int _height = 0;
  String _team = '';
  String _position = '';
  int _jerseyNumber = 0;

  @override
  void initState() {
    super.initState();

    _firstName = widget.player.firstName;
    _lastName = widget.player.lastName;
    _height = widget.player.height;
    _team = widget.player.teamID;
    _position = widget.player.position;
    _jerseyNumber = widget.player.jerseyNumber;

    // Initialize the text controllers with the player's current information
    firstNameController.text = widget.player.firstName;
    lastNameController.text = widget.player.lastName;
    heightController.text = widget.player.height.toString();
    teamController.text = widget.player.teamID;
    positionController.text = widget.player.position;
    jerseyNumberController.text = widget.player.jerseyNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.player.firstName} ${widget.player.lastName}'),
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PlayersPage()),
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
          _buildDetailRow('First Name', _firstName),
          _buildDetailRow('Last Name', _lastName),
          _buildDetailRow('Height', '$_height inches'),
          _buildDetailRow('Team', _team),
          _buildDetailRow('Position', _position),
          _buildDetailRow('Jersey Number', _jerseyNumber.toString()),
        ],
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
          title: const Text('Edit Player Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('First Name', firstNameController),
                _buildTextField('Last Name', lastNameController),
                _buildTextField('Height (in inches)', heightController),
                _buildTextField('Team', teamController),
                _buildTextField('Position', positionController),
                _buildTextField('Jersey Number', jerseyNumberController),
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
                // Update player information here
                _updatePlayerInformation();
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

  void _updatePlayerInformation() {
    setState(() {
      // Update the player information
      _firstName = firstNameController.text;
      _lastName = lastNameController.text;
      _height = int.parse(heightController.text);
      _team = teamController.text;
      _position = positionController.text;
      _jerseyNumber = int.parse(jerseyNumberController.text);
    });

    db.updatePlayer(
      playerID: widget.player.playerID,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      height: int.parse(heightController.text),
      teamID: teamController.text,
      position: positionController.text,
      jerseyNumber: int.parse(jerseyNumberController.text),
    );

    print('Updated Information:');
    print('First Name: ${firstNameController.text}');
    print('Last Name: ${lastNameController.text}');
    print('Height: ${heightController.text}');
    print('Team: ${teamController.text}');
    print('Position: ${positionController.text}');
    print('Jersey Number: ${jerseyNumberController.text}');
  }
}
