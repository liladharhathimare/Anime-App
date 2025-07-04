import 'package:flutter/material.dart';
import '../api/get_animes_by_ranking_type_anilist.dart';
import '../models/anime.dart';
import '../views/ranked_animes_list_view.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';

class ViewAllAnimesScreen extends StatefulWidget {
  const ViewAllAnimesScreen({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType; // e.g. 'popular', 'score', 'airing'
  final String label;

  static const routeName = '/view-all-animes';

  @override
  State<ViewAllAnimesScreen> createState() => _ViewAllAnimesScreenState();
}

class _ViewAllAnimesScreenState extends State<ViewAllAnimesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.label)),
      body: FutureBuilder<List<Anime>>(
        future: getAnimesByRankingType( // ✅ fixed method name
          rankingType: widget.rankingType,
          limit: 50,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error.toString());
          }

          if (snapshot.hasData) {
            final animes = snapshot.data!;
            return RankedAnimesListView(animes: animes);
          }

          return const Center(child: Text('No anime found.'));
        },
      ),
    );
  }
}
