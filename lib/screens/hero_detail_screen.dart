// import 'package:flutter/material.dart';

// class HeroDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> heroDetails;

//   const HeroDetailsScreen({super.key, required this.heroDetails});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(heroDetails['data']['name']),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               heroDetails['data']['cover_picture'],
//               height: 150,
//             ),
//             const SizedBox(height: 16.0),
//             Text('Type: ${heroDetails['data']['type']}'),
//             const SizedBox(height: 8.0),
//             Text('Physical Attack: ${heroDetails['data']['phy']}'),
//             const SizedBox(height: 8.0),
//             Text('Magic Attack: ${heroDetails['data']['mag']}'),
//             const SizedBox(height: 8.0),
//             Text('Difficulty: ${heroDetails['data']['diff']}'),
//             const SizedBox(height: 16.0),
//             const Text('Skills:',
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: (heroDetails['data']['skill']['skill'] as List<dynamic>)
//                   .map((skill) => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 8.0),
//                           Text(skill['name'],
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 4.0),
//                           Text(skill['des']),
//                         ],
//                       ))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class HeroDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic>? heroDetails;

//   const HeroDetailsScreen({super.key, required this.heroDetails});

//   @override
//   Widget build(BuildContext context) {
//     if (heroDetails == null || heroDetails!['data'] == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Hero Details'),
//         ),
//         body: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     final data = heroDetails!['data'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(data['name']),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               data['cover_picture'],
//               height: 150,
//             ),
//             const SizedBox(height: 16.0),
//             Text('Type: ${data['type']}'),
//             const SizedBox(height: 8.0),
//             Text('Physical Attack: ${data['phy']}'),
//             const SizedBox(height: 8.0),
//             Text('Magic Attack: ${data['mag']}'),
//             const SizedBox(height: 8.0),
//             Text('Difficulty: ${data['diff']}'),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Skills:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: (data['skill']['skill'] as List<dynamic>)
//                   .map(
//                     (skill) => Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 8.0),
//                         Text(
//                           skill['name'],
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 4.0),
//                         Text(skill['des']),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeroDetailScreen extends StatelessWidget {
  final String heroid;

  const HeroDetailScreen({super.key, required this.heroid});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHeroDetails(heroid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data found'),
            );
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    data['cover_picture'],
                    height: 150,
                  ),
                  const SizedBox(height: 16.0),
                  Text('Type: ${data['type']}'),
                  const SizedBox(height: 8.0),
                  Text('Physical Attack: ${data['phy']}'),
                  const SizedBox(height: 8.0),
                  Text('Magic Attack: ${data['mag']}'),
                  const SizedBox(height: 8.0),
                  Text('Difficulty: ${data['diff']}'),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Skills:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (data['skill']['skill'] as List<dynamic>)
                        .map(
                          (skill) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              Text(
                                skill['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(skill['des']),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
