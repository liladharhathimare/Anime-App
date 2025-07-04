import 'package:flutter/material.dart';
import '../api/get_animes_by_ranking_type_anilist.dart';
import '../core/widgets/loader.dart';
import '../models/anime.dart';
import '../widgets/top_animes_image_slider.dart';

class TopAnimesList extends StatelessWidget {
  const TopAnimesList({
    super.key,
    required this.rankingType,
  });

  final String rankingType;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anime>>(
      future: getAnimesByRankingType(
        rankingType: rankingType,
        limit: 4,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No top animes found.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        final animes = snapshot.data!;
        return TopAnimesImageSlider(animes: animes);
      },
    );
  }
}
