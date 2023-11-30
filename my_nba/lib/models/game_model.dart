import 'package:flutter/material.dart';

class Game{
  final int gameID;
  final String team1ID;
  final String team2ID;
  final String court;
  final String date;
  final String time;

  Game(
      {required this.gameID,
      required this.team1ID,
      required this.team2ID,
      required this.court,
      required this.date,
      required this.time,
      });

      factory Game.fromSqfliteDatbase(Map<String, dynamic> data) {
        return Game(gameID: data['gameID'], 
          team1ID: data['team1ID'], 
          team2ID: data['team2ID'], 
          court: data['court'], 
          date: data['date'], 
          time: data['time']);
      }
}
