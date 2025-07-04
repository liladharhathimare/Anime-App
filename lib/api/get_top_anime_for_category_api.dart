import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getCategoryPictureApi({
  required String category,
}) async {
  const String url = 'https://graphql.anilist.co';

  const String query = r'''
    query ($sort: [MediaSort]) {
      Page(perPage: 1) {
        media(type: ANIME, sort: $sort) {
          coverImage {
            large
          }
        }
      }
    }
  ''';


  final Map<String, List<String>> categorySort = {
    'airing': ['TRENDING_DESC', 'START_DATE_DESC'],
    'upcoming': ['START_DATE_DESC'],
    'popular': ['POPULARITY_DESC'],
    'top': ['SCORE_DESC'],
  };

  final List<String>? sort = categorySort[category.toLowerCase()];
  if (sort == null) throw Exception('Invalid category: $category');

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'query': query,
      'variables': {'sort': sort},
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['Page']['media'][0]['coverImage']['large'];
  } else {
    throw Exception("Failed to fetch image: ${response.body}");
  }
}
