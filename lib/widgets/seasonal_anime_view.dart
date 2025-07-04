import 'package:flutter/material.dart';

import '/api/get_seasonal_animes_api.dart';
import '/screens/anime_details_screen.dart';
import '/screens/view_all_seasonal_animes_screen.dart';
import '/models/anime.dart';
import '/widgets/anime_tile.dart';

class SeasonalAnimeView extends StatelessWidget {
  const SeasonalAnimeView({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anime>>(
      future: getSeasonalAnimesApi(limit: 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No seasonal animes found.');
        }

        final animes = snapshot.data!;

        return Column(
          children: [
            // Header with label and View all
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      Navigator.of(context).pushNamed(
                        ViewAllSeasonalAnimesScreen.routeName,
                        arguments: {
                          'label': label,
                        },
                      );
                    },
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
            // Horizontal anime list
            SizedBox(
              height: 300,
              child: ListView.separated(
                itemCount: animes.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  final anime = animes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AnimeDetailsScreen.routeName,
                        arguments: anime.id,
                      );
                    },
                    child: AnimeTile(
                      anime: anime,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
