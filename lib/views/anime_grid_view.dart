import 'package:anime_world_tutorial/api/get_animes_by_ranking_type_anilist.dart';
import 'package:anime_world_tutorial/core/screens/error_screen.dart';
import 'package:anime_world_tutorial/core/widgets/loader.dart';
import 'package:anime_world_tutorial/models/anime.dart';
import 'package:anime_world_tutorial/models/anime_category.dart';
import 'package:anime_world_tutorial/views/animes_grid_list.dart';
import 'package:flutter/material.dart';

class AnimeGridView extends StatelessWidget {
  const AnimeGridView({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anime>>(
      future: getAnimesByRankingType(
        rankingType: category.rankingType,
        limit: 100,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasError) {
          return ErrorScreen(error: snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No animes found in this category.'));
        }

        final animes = snapshot.data!;
        return AnimesGridList(
          title: category.title,
          animes: animes,
        );
      },
    );
  }
}
