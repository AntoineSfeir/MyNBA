import 'package:flutter/material.dart';

class Game {
  int gameID;
  String team1ID;
  String team2ID;
  String court;
  DateTime date;
  TimeOfDay time;

  Game({
    required this.gameID,
    required this.team1ID,
    required this.team2ID,
    required this.court,
    required this.date,
    required this.time,
  });

  // Convert a Game object to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'gameID': gameID,
      'team1ID': team1ID,
      'team2ID': team2ID,
      'court': court,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }

  // Create a Game object from a map received from the database
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameID: map['gameID'],
      team1ID: map['team1ID'],
      team2ID: map['team2ID'],
      court: map['court'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
    );
  }
}
