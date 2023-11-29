import 'package:flutter/material.dart';
import 'package:my_nba/data/team_db.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  TeamDb db = TeamDb();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamIDController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _homecourtController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Team ID', _teamIDController),
              _buildTextField('City', _cityController),
              _buildTextField('Homecourt', _homecourtController),
              _buildTextField('Division', _divisionController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveTeam();
                },
                child: const Text('Create Team'),
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
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _saveTeam() {
    if (_formKey.currentState!.validate()) {
      db.insertTeam(
          teamID: _teamIDController.text,
          city: _cityController.text,
          homecourt: _homecourtController.text,
          division: _divisionController.text);
      Navigator.pop(context);
    }
  }
}
