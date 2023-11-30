import 'package:flutter/material.dart';
import 'package:my_nba/data/game_db.dart';
import 'package:my_nba/pages/home_page.dart';
import 'package:my_nba/models/game_model.dart';
import 'package:my_nba/pages/games_page/game_page.dart';
import 'package:my_nba/pages/team_pages/teams_page.dart';
import 'package:my_nba/pages/player_pages/players_page.dart';
import 'package:my_nba/pages/games_page/create_game_page.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  Future<List<Game>>? futureGames;
  final GameDb gameDb = GameDb();

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  void fetchGames() {
    setState(() {
      futureGames = gameDb.fetchAllGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateGamePage()),
            ).then((_) {
              // Reload the players when returning from the create player page
              fetchGames();
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.add_task,
            color: Colors.black,
          ),
        ),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
            body: FutureBuilder<List<Game>>(
              future: futureGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, show a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If the Future throws an error, display an error message
                    return Center(child: SelectableText('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // If the Future is completed but no data is available, show a message
                    return const Center(child: Text('No Teams available.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${snapshot.data![index].team1ID} VS ${snapshot.data![index].team2ID}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle:
                                Text(snapshot.data![index].date.toString()),
                            trailing: Text(snapshot.data![index].court),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GamePage(
                                    game: snapshot.data![index],
                                  ),
                                ),
                              ).then((_) {
                                // Reload the players when returning from the create player page
                                fetchGames();
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            )),
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
