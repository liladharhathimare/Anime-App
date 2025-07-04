import 'package:flutter/material.dart';
import '../api/get_animes_by_ranking_type_anilist.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/models/anime_category.dart';
import '../views/anime_list_view.dart';
import '../models/anime.dart';

class CategoryAnimesScreen extends StatelessWidget {
  const CategoryAnimesScreen({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  static const routeName = '/categories-anime';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anime>>(
      future: getAnimesByRankingType(
        rankingType: category.rankingType,
        limit: 500,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasData) {
          final List<Anime> animes = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(category.title),
            ),
            body: AnimeListView(animes: animes),
          );
        }

        return ErrorScreen(
          error: snapshot.error.toString(),
        );
      },
    );
  }
}
