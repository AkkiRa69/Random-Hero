// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ml_random_hero/constants/hero.dart';
// import 'package:ml_random_hero/screens/hero_detail_screen.dart';

// class HeroesListScreen extends StatefulWidget {
//   const HeroesListScreen({super.key});

//   @override
//   _HeroesListScreenState createState() => _HeroesListScreenState();
// }

// class _HeroesListScreenState extends State<HeroesListScreen> {
//   List<HeroData> heroes = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final response =
//         await http.get(Uri.parse('https://mapi.mobilelegends.com/hero/list'));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       print(jsonData); // Print JSON response for debugging
//       List<HeroData> fetchedHeroes = [];
//       for (var hero in jsonData['data']) {
//         fetchedHeroes.add(HeroData.fromJson(hero));
//       }
//       setState(() {
//         heroes = fetchedHeroes;
//       });
//     } else {
//       throw Exception('Failed to load heroes');
//     }
//   }

//   Future<Map<String, dynamic>> fetchHeroDetails(String heroId) async {
//     final String apiUrl =
//         'https://mapi.mobilelegends.com/hero/detail?id=$heroId';

//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load hero details');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   void navigateToHeroDetails(String heroId) async {
//     try {
//       var heroDetails = await fetchHeroDetails(heroId);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HeroDetailsScreen(heroDetails: heroDetails),
//         ),
//       );
//     } catch (e) {
//       print('Error fetching hero details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mobile Legends Heroes'),
//       ),
//       body: ListView.builder(
//         itemCount: heroes.length,
//         itemBuilder: (BuildContext context, int index) {
//           debugPrint(heroes[index].key);
//           return ListTile(
//             leading: Image.network(
//               'https:${heroes[index].key}',
//             ),
//             title: Text(heroes[index].name),
//             subtitle: Text('Hero ID: ${heroes[index].heroid}'),
//             onTap: () {
//               navigateToHeroDetails(heroes[index].heroid);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
