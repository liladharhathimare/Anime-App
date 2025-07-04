import 'package:flutter/material.dart';
import 'package:anime_world_tutorial/api/get_animes_by_ranking_type_anilist.dart';
import 'package:anime_world_tutorial/core/screens/error_screen.dart';
import 'package:anime_world_tutorial/core/widgets/loader.dart';
import 'package:anime_world_tutorial/screens/view_all_animes_screen.dart';
import 'package:anime_world_tutorial/widgets/anime_tile.dart';

class FeaturedAnimes extends StatelessWidget {
  final String rankingType;
  final String label;

  const FeaturedAnimes({
    super.key,
    required this.rankingType,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAnimesByRankingType(
        rankingType: rankingType,
        limit: 10,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasData) {
          final animes = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with label and View All
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ViewAllAnimesScreen(
                              rankingType: rankingType,
                              label: label,
                            ),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),

              // Horizontal Anime List
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: animes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return AnimeTile(anime: animes[index]);
                  },
                ),
              ),
            ],
          );
        }

        return ErrorScreen(error: snapshot.error.toString());
      },
    );
  }
}
