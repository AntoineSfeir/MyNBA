import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/data/database_helper.dart'; // Import your Player model

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _teamIDController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }
  // Method to retrieve players from the database
  // Method to retrieve players from the database
  Future<List<Player>> _getPlayers() async {
    return await _databaseHelper.getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _jerseyNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jersey Number'),
            ),
            TextField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            TextField(
              controller: _teamIDController,
              decoration: const InputDecoration(labelText: 'Team ID'),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _insertPlayer();
                  },
                  child: const Text('Create Player'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _updatePlayer();
                  },
                  child: const Text('Update Player'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _deletePlayer();
                  },
                  child: const Text('Delete Player'),
                ),
              ],
            ),

            // Display current players
            const SizedBox(height: 16),
            const Text('Current Players:'),
            FutureBuilder<List<Player>>(
              future: _getPlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Player>? players = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: players?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(players?[index].firstName ?? ''),
                          subtitle: Text(
                              'Jersey Number: ${players?[index].jerseyNumber} | Position: ${players?[index].position}'),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

void _insertPlayer() async {
  String firstName = _firstNameController.text.trim();
  String lastName = _lastNameController.text.trim();
  String heightText = _heightController.text.trim();
  String teamID = _teamIDController.text.trim();
  String position = _positionController.text.trim();
  String jerseyNumberText = _jerseyNumberController.text.trim();

  if (firstName.isEmpty ||
      lastName.isEmpty ||
      heightText.isEmpty ||
      teamID.isEmpty ||
      position.isEmpty ||
      jerseyNumberText.isEmpty) {
    // Show an error message or handle the case where any field is empty
    print('All fields must be filled');
    return;
  }

  try {
    int height = int.parse(heightText);
    int jerseyNumber = int.parse(jerseyNumberText);

    // Generate a random player ID using uuid
    String playerID = Uuid().v4();

    Player newPlayer = Player(
      playerID: int.parse(playerID),
      firstName: firstName,
      lastName: lastName,
      height: height,
      teamID: teamID,
      position: position,
      jerseyNumber: jerseyNumber,
    );

    int playerId = await _databaseHelper.insertPlayer(newPlayer);
    print('Player inserted with ID: $playerId');
  } catch (e) {
    // Handle the case where parsing fails (non-numeric input)
    print('Invalid input. Height and Jersey Number must be numeric.');
  }
}

  void _updatePlayer() async {
    // Assuming you have the player ID from somewhere (e.g., selected player)
    int playerIdToUpdate = 1; // Replace with the actual player ID

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    int height = int.parse(_heightController.text.trim());
    String teamID = _teamIDController.text.trim();
    String position = _positionController.text.trim();
    int jerseyNumber = int.parse(_jerseyNumberController.text.trim());

    Player updatedPlayer = Player(
      playerID: playerIdToUpdate,
      firstName: firstName,
      lastName: lastName,
      height: height,
      teamID: teamID,
      position: position,
      jerseyNumber: jerseyNumber,
    );

    int rowsAffected = await _databaseHelper.updatePlayer(updatedPlayer);
    print('Updated $rowsAffected player(s)');
  }

  void _deletePlayer() async {
    // Assuming you have the player ID from somewhere (e.g., selected player)
    int playerIdToDelete = 1; // Replace with the actual player ID

    int rowsDeleted = await _databaseHelper.deletePlayer(playerIdToDelete);
    print('Deleted $rowsDeleted player(s)');
  }
}
