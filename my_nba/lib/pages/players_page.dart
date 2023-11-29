import 'package:flutter/material.dart';
import 'package:my_nba/data/player_db.dart';
import 'package:my_nba/pages/home_page.dart';
import 'package:my_nba/pages/teams_page.dart';
import 'package:my_nba/pages/player_page.dart';
import 'package:my_nba/models/player_model.dart';
import 'package:my_nba/pages/create_player_page.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  Future<List<Player>>? futurePlayers;
  final PlayerDb playerDb = PlayerDb();

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  void fetchPlayers() {
    setState(() {
      futurePlayers = playerDb.fetchAllPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePlayerPage()),
            ).then((_) {
              // Reload the players when returning from the create player page
              fetchPlayers();
            });
          },
          child: const Icon(Icons.add),
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
                    title: const Text("All Players",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        )),
                    background: Image.network(
                      "https://images7.alphacoders.com/344/344223.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: FutureBuilder<List<Player>>(
            future: futurePlayers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If the Future throws an error, display an error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // If the Future is completed but no data is available, show a message
                return const Center(child: Text('No players available.'));
              } else {
                // If the Future is completed and data is available, display the list of players
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Player player = snapshot.data![index];
                    String firstName = player.firstName;
                    String lastName = player.lastName;
                    String team = player.teamID;
                    return ListTile(
                      title: Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Team: $team",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // Add more player details as needed
                        ],
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerPage(player: player),
                            ));
                      },
                    );
                  },
                );
              }
            },
          ),
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TeamsPage()),
                    );
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
