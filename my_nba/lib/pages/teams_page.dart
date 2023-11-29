import 'package:flutter/material.dart';
import 'package:my_nba/data/team_db.dart';
import 'package:my_nba/pages/home_page.dart';
import 'package:my_nba/pages/team_page.dart';
import 'package:my_nba/models/team_model.dart';
import 'package:my_nba/pages/players_page.dart';
import 'package:my_nba/pages/create_team_page.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  Future<List<Team>>? futureTeams;
  final TeamDb teamDb = TeamDb();

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  void fetchTeams() {
    setState(() {
      futureTeams = teamDb.fetchAllTeams();
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
              MaterialPageRoute(builder: (context) => CreateTeamPage()),
            ).then((_) {
              // Reload the players when returning from the create player page
              fetchTeams();
            });
          },
          child: const Icon(Icons.add),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                stretch: true,
                 backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: const Text("All Teams",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        )),
                    background: Image.network(
                      "https://wallpapers.com/images/hd/nba-team-logos-7dyfrznb0x44wxup.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: FutureBuilder<List<Team>>(
            future: futureTeams,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If the Future throws an error, display an error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // If the Future is completed but no data is available, show a message
                return const Center(child: Text('No Teams available.'));
              } else {
                // If the Future is completed and data is available, display the list of players
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Team team = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        team.teamID,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "City: ${team.city}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // Add more player details as needed
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamPage(team: team),
                          ),
                        );
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlayersPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.group),
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
