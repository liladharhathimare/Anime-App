import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/anime.dart'; // Your Anime model with fromAniListJson

Future<List<Anime>> getSeasonalAnimesApi({required int limit}) async {
  final int year = DateTime.now().year;
  final String season = getCurrentSeasonAniList(); // WINTER, SPRING, SUMMER, FALL

  const String url = 'https://graphql.anilist.co';

  const String query = r'''
    query ($season: MediaSeason, $seasonYear: Int, $perPage: Int) {
      Page(perPage: $perPage) {
        media(season: $season, seasonYear: $seasonYear, type: ANIME) {
          id
          title {
            romaji
            english
            native
          }
          coverImage {
            large
          }
        }
      }
    }
  ''';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': query,
        'variables': {
          'season': season,
          'seasonYear': year,
          'perPage': limit,
        },
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> mediaList =
      jsonDecode(response.body)['data']['Page']['media'];

      return mediaList.map((json) => Anime.fromAniListJson(json)).toList();
    } else {
      debugPrint("Error: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
      throw Exception("Failed to fetch seasonal anime");
    }
  } catch (e) {
    debugPrint("Exception: $e");
    throw Exception("Error fetching seasonal anime");
  }
}


String getCurrentSeasonAniList() {
  final int month = DateTime.now().month;
  if (month >= 1 && month <= 3) return 'WINTER';
  if (month >= 4 && month <= 6) return 'SPRING';
  if (month >= 7 && month <= 9) return 'SUMMER';
  return 'FALL';
}
