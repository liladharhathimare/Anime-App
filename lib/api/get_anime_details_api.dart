import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/anime_details.dart';

Future<AnimeDetails> getAnimeDetailsApi({required int id}) async {
  const String url = 'https://graphql.anilist.co';

  const String query = r'''
    query ($id: Int) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        coverImage {
          large
        }
        description
        episodes
        duration
        genres
        averageScore
        popularity
        startDate {
          year
          month
          day
        }
        endDate {
          year
          month
          day
        }
        status
        studios {
          nodes {
            name
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
        'variables': {'id': id},
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final dynamic media = data['data']['Media'];

      return AnimeDetails.fromAniListJson(media);
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      throw Exception('Failed to load anime details');
    }
  } catch (e) {
    debugPrint('Exception: $e');
    throw Exception('An error occurred while fetching anime details');
  }
}
