import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ml_random_hero/constants/hero.dart';
import 'package:ml_random_hero/screens/hero_detail_screen.dart';
import 'package:ml_random_hero/screens/hero_search_screen.dart';

class HeroTypeList extends StatefulWidget {
  const HeroTypeList({
    super.key,
  });

  @override
  _HeroTypeListState createState() => _HeroTypeListState();
}

class _HeroTypeListState extends State<HeroTypeList> {
  List<HeroData> heroes = [];
  List<HeroData> fighterHeroes = [];
  List<HeroData> marksmanHeroes = [];
  List<HeroData> mageHeroes = [];
  List<HeroData> tankHeroes = [];
  List<HeroData> supportHeroes = [];
  List<HeroData> assassinHeroes = [];
  HeroData? randomFighter;
  HeroData? randomMarksman;
  HeroData? randomMage;
  HeroData? randomTank;
  HeroData? randomSupport;
  HeroData? randomAssassin;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://mapi.mobilelegends.com/hero/list'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<HeroData> fetchedHeroes = [];
      for (var hero in jsonData['data']) {
        fetchedHeroes.add(HeroData.fromJson(hero));
      }
      setState(() {
        heroes = fetchedHeroes;
      });

      // Categorize heroes by type
      for (var hero in heroes) {
        await categorizeHero(hero);
      }
    } else {
      throw Exception('Failed to load heroes');
    }
  }

  Future<Map<String, dynamic>> fetchHeroDetails(String heroId) async {
    final String apiUrl =
        'https://mapi.mobilelegends.com/hero/detail?id=$heroId';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['code'] == 2000) {
          // Successfully fetched hero details
          return jsonData['data'];
        } else {
          throw Exception(
              'Failed to load hero details: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load hero details');
      }
    } catch (e) {
      throw Exception('Error fetching hero details: $e');
    }
  }

  Future<void> categorizeHero(HeroData hero) async {
    try {
      var heroDetails = await fetchHeroDetails(hero.heroid);
      switch (heroDetails['type']) {
        case 'Fighter':
          setState(() {
            fighterHeroes.add(hero);
          });
          break;
        case 'Marksman':
          setState(() {
            marksmanHeroes.add(hero);
          });
          break;
        case 'Mage':
          setState(() {
            mageHeroes.add(hero);
          });
          break;
        case 'Tank':
          setState(() {
            tankHeroes.add(hero);
          });
          break;
        case 'Support':
          setState(() {
            supportHeroes.add(hero);
          });
          break;
        case 'Assassin':
          setState(() {
            assassinHeroes.add(hero);
          });
          break;
        default:
          break;
      }
    } catch (e) {
      print('Error categorizing hero: $e');
    }
  }

  void selectRandomHeroes() {
    final random = Random();
    setState(() {
      if (fighterHeroes.isNotEmpty) {
        randomFighter = fighterHeroes[random.nextInt(fighterHeroes.length)];
      }
      if (marksmanHeroes.isNotEmpty) {
        randomMarksman = marksmanHeroes[random.nextInt(marksmanHeroes.length)];
      }
      if (mageHeroes.isNotEmpty) {
        randomMage = mageHeroes[random.nextInt(mageHeroes.length)];
      }
      if (tankHeroes.isNotEmpty) {
        randomTank = tankHeroes[random.nextInt(tankHeroes.length)];
      }
      if (supportHeroes.isNotEmpty) {
        randomSupport = supportHeroes[random.nextInt(supportHeroes.length)];
      }
      if (assassinHeroes.isNotEmpty) {
        randomAssassin = assassinHeroes[random.nextInt(assassinHeroes.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            selectRandomHeroes();
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildRandomHero('Random Fighter',
                        randomFighter != null ? [randomFighter!] : []),
                    buildRandomHero('Random Marksman',
                        randomMarksman != null ? [randomMarksman!] : []),
                    buildRandomHero(
                        'Random Mage', randomMage != null ? [randomMage!] : []),
                    buildRandomHero(
                        'Random Tank', randomTank != null ? [randomTank!] : []),
                    buildRandomHero('Random Support',
                        randomSupport != null ? [randomSupport!] : []),
                    buildRandomHero('Random Assassin',
                        randomAssassin != null ? [randomAssassin!] : []),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.shuffle),
        ),
        appBar: AppBar(
          title: Text(
            'Make Your Choice Easy',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeroSearchScreen(allHeroes: heroes),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.blue,
            tabs: [
              Tab(text: 'Fighter'),
              Tab(text: 'Marksman'),
              Tab(text: 'Assassin'),
              Tab(text: 'Tank'),
              Tab(text: 'Support'),
              Tab(text: 'Mage'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildHeroTypeList('Fighter', fighterHeroes),
            buildHeroTypeList('Marksman', marksmanHeroes),
            buildHeroTypeList('Assassin', assassinHeroes),
            buildHeroTypeList('Tank', tankHeroes),
            buildHeroTypeList('Support', supportHeroes),
            buildHeroTypeList('Mage', mageHeroes),
          ],
        ),
      ),
    );
  }

  Widget buildRandomHero(String type, List<HeroData> heroesList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            type,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: heroesList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network('https:${heroesList[index].key}')),
              title: Text(heroesList[index].name),
              subtitle: Text('Hero ID: ${heroesList[index].heroid}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HeroDetailScreen(heroid: heroesList[index].heroid),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildHeroTypeList(String type, List<HeroData> heroesList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GridView.builder(
        itemCount: heroesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HeroDetailScreen(heroid: heroesList[index].heroid),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    'https:${heroesList[index].key}',
                    scale: 0.5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.05),
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Text(
                      heroesList[index].name,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
