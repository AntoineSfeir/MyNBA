import 'package:flutter/material.dart';
import 'package:my_nba/pages/teams_page.dart';
import 'package:my_nba/pages/players_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


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
                  title: const Text("My NBA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      )),
                  background: Image.network(
                    "https://wallpapers.com/images/hd/golden-nba-finals-poster-4bh8i5ptqhb4m4h9.jpg",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: const Text(""),
      ),
       bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                 IconButton(
                  icon: const Icon(Icons.home_rounded),
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomePage()),
                    // );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayersPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.group),
                  onPressed: () {
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => const TeamsPage()),
                     );
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
