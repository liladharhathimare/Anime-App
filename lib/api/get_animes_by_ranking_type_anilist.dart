import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

Future<List<Anime>> getAnimesByRankingType({
  required String rankingType,
  required int limit,
}) async {
  const String url = 'https://graphql.anilist.co';

  const String query = r'''
    query ($sort: [MediaSort], $perPage: Int) {
      Page(perPage: $perPage) {
        media(type: ANIME, sort: $sort) {
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

  final sort = _mapRankingTypeToAniListSort(rankingType);

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'query': query,
      'variables': {
        'sort': [sort],
        'perPage': limit,
      },
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    if (json['data'] == null || json['data']['Page'] == null) {
      throw Exception('Invalid API response');
    }

    final List mediaList = json['data']['Page']['media'] ?? [];
    return mediaList.map((json) => Anime.fromAniListJson(json)).toList();
  } else {
    throw Exception('AniList API error: ${response.statusCode}\n${response.body}');
  }
}

String _mapRankingTypeToAniListSort(String type) {
  switch (type.toLowerCase()) {
    case 'all':
    case 'score':
    case 'rated':
      return 'SCORE_DESC';
    case 'popular':
    case 'popularity':
      return 'POPULARITY_DESC';
    case 'upcoming':
      return 'START_DATE_DESC';
    case 'airing':
      return 'TRENDING_DESC';
    default:
      return 'SCORE_DESC';
  }
}
