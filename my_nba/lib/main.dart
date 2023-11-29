import 'package:flutter/material.dart';
import 'package:my_nba/pages/players_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor customBlack = const MaterialColor(
      0xFF000000, // Black primary color value
      <int, Color>{
        50: Color(
            0xFF000000), // Shades of black for lighter variations if needed
        100: Color(0xFF000000),
        200: Color(0xFF000000),
        300: Color(0xFF000000),
        400: Color(0xFF000000),
        500: Color(0xFF000000),
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My NBA',
      theme: ThemeData(
        primarySwatch: customBlack,
      ),
      home: const PlayersPage(),
    );
  }
}
