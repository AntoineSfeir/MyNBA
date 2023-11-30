import 'package:flutter/material.dart';
import 'package:my_nba/pages/home_page.dart';
import 'package:my_nba/pages/team_pages/teams_page.dart';
import 'package:my_nba/pages/player_pages/players_page.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const CreateGamePage()),
            // ).then((_) {
            //   // Reload the players when returning from the create player page
            //   fetchGames();
            // });
          },
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.add_task,
            color: Colors.black,
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 450.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: const Text("Games",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        )),
                    background: Image.network(
                      "https://wallpapers.com/images/hd/michael-jordan-fade-away-of-nba-3k0pl8gbo4riohoa.webp",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: const Text("Games Page"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home_rounded),
                  onPressed: () {
                     Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
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
                IconButton(
                  icon: const Icon(Icons.sports_basketball),
                  onPressed: () {
                
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
