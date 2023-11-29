import 'package:flutter/material.dart';
import 'package:my_nba/data/sql_console.dart';
import 'package:my_nba/pages/teams_page.dart';
import 'package:my_nba/pages/players_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _queryController = TextEditingController();
  final SqlConsole _sqlConsole = SqlConsole();
  late AnimationController _animationController;

  String _queryResult = '';
  bool _sqlSectionVisible = false;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 450.0,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: const Text(
                "My NBA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              background: Image.network(
                "https://wallpapers.com/images/hd/golden-nba-finals-poster-4bh8i5ptqhb4m4h9.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Toggle SQL Console',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                  icon: _sqlSectionVisible
                      ? const Icon(Icons.keyboard_arrow_down)
                      : const Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() {
                      _sqlSectionVisible = !_sqlSectionVisible;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: _sqlSectionVisible,
              child: _buildSqlSection(),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: BottomAppBar(
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSqlSection() {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _queryController,
          decoration: InputDecoration(
            labelText: 'SQL Console',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                setState(() {
                  _sqlConsole
                      .runQuery(_queryController.text)
                      .then((value) => _queryResult = value);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Output',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _queryResult,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



}
