import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/anime.dart';

Future<List<Anime>> getAnimesBySearchApi({required String query}) async {
  const String url = 'https://graphql.anilist.co';

  const String gqlQuery = r'''
    query ($search: String) {
      Page(perPage: 10) {
        media(search: $search, type: ANIME) {
          id
          title {
            romaji
            english
            native
          }
          coverImage {
            large
          }
          averageScore
          popularity
        }
      }
    }
  ''';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'query': gqlQuery,
        'variables': {'search': query},
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> mediaList = data['data']['Page']['media'];

      return mediaList
          .map<Anime>((anime) => Anime.fromAniListJson(anime))
          .toList();
    } else {
      debugPrint("HTTP Error: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      throw Exception("Failed to fetch anime search data");
    }
  } catch (e) {
    debugPrint("Exception during API call: $e");
    throw Exception("Error occurred while searching anime");
  }
}
