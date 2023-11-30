import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_nba/data/player_db.dart';

class CreatePlayerPage extends StatefulWidget {
  const CreatePlayerPage({super.key});

  @override
  _CreatePlayerPageState createState() => _CreatePlayerPageState();
}

class _CreatePlayerPageState extends State<CreatePlayerPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController jerseyNumberController = TextEditingController();

  PlayerDb db = PlayerDb();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Player'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Add your back button functionality here
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('First Name', firstNameController),
              _buildTextField('Last Name', lastNameController),
              _buildTextField('Height (in inches)', heightController),
              _buildTextField('Team', teamController),
              _buildTextField('Position', positionController),
              _buildTextField('Jersey Number', jerseyNumberController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _savePlayer();
                },
                child: const Text('Add Player'),
              ),
            ],
          ),
        ),
      ),
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

  void _savePlayer() {
    // Generate a random playerID using Dart's Random class
    int playerID =
        Random().nextInt(10000); // Adjust the range based on your requirements

    // Get other player details from controllers
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    int height = int.tryParse(heightController.text) ?? 0;
    String team = teamController.text;
    String position = positionController.text;
    int jerseyNumber = int.tryParse(jerseyNumberController.text) ?? 0;

    // Save the player details to the database
    db.insertPlayer(
      playerID: playerID
          .toString(), // Convert to string if your database expects it as a string
      firstName: firstName,
      lastName: lastName,
      height: height,
      teamName: team,
      position: position,
      jerseyNumber: jerseyNumber,
    );

    // After saving, you can navigate back or perform other actions
    Navigator.pop(
        context, true); // Return true to indicate that a new player was added
  }
}
