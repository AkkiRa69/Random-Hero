import 'package:flutter/material.dart';
import 'package:ml_random_hero/constants/hero.dart';
import 'package:ml_random_hero/screens/hero_detail_screen.dart';

class HeroSearchScreen extends StatefulWidget {
  final List<HeroData> allHeroes;

  const HeroSearchScreen({super.key, required this.allHeroes});

  @override
  _HeroSearchScreenState createState() => _HeroSearchScreenState();
}

class _HeroSearchScreenState extends State<HeroSearchScreen> {
  List<HeroData> filteredHeroes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredHeroes = widget.allHeroes;
  }

  void filterHeroes(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredHeroes = widget.allHeroes;
      });
    } else {
      setState(() {
        filteredHeroes = widget.allHeroes
            .where(
                (hero) => hero.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search for a hero',
            border: InputBorder.none,
          ),
          onChanged: filterHeroes,
        ),
      ),
      body: ListView.builder(
        itemCount: filteredHeroes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network('https:${filteredHeroes[index].key}')),
            title: Text(filteredHeroes[index].name),
            subtitle: Text('Hero ID: ${filteredHeroes[index].heroid}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroDetailScreen(
                  heroid: filteredHeroes[index].heroid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
