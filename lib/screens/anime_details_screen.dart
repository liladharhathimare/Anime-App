import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/api/get_anime_details_api.dart';
import '/common/styles/paddings.dart';
import '/common/styles/text_styles.dart';
import '/common/widgets/ios_back_button.dart';
import '/common/widgets/network_image_view.dart';
import '/common/widgets/read_more_text.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/models/anime_details.dart';

class AnimeDetailsScreen extends StatelessWidget {
  const AnimeDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  static const routeName = '/anime-details';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnimeDetails>(
      future: getAnimeDetailsApi(id: id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasError) {
          return ErrorScreen(
            error: snapshot.error.toString(),
          );
        }

        if (snapshot.hasData) {
          final anime = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimeImage(
                    imageUrl: anime.coverImageUrl ?? '',
                  ),
                  Padding(
                    padding: Paddings.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        _buildAnimeName(
                          defaultName: anime.titleRomaji ?? '',
                          englishName: anime.titleEnglish ?? '',
                        ),

                        const SizedBox(height: 20),

                        // Description
                        ReadMoreText(
                          longText: anime.description ?? 'No description available.',
                        ),

                        const SizedBox(height: 10),

                        _buildAnimeInfo(
                          anime: anime,
                        ),

                        const SizedBox(height: 20),

                        // Related Images or Gallery
                        _buildAnimeImages(pictures: anime.pictures),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Loader(); // fallback loading state
      },
    );
  }

  Widget _buildAnimeImage({
    required String imageUrl,
  }) =>
      Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 400,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Image not available'));
            },
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Builder(builder: (context) {
              return IosBackButton(
                onPressed: Navigator.of(context).pop,
              );
            }),
          ),
        ],
      );

  Widget _buildAnimeName({
    required String englishName,
    required String defaultName,
  }) =>
      BlocBuilder<AnimeTitleLanguageCubit, bool>(
        builder: (context, state) {
          return Text(
            state && englishName.isNotEmpty ? englishName : defaultName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      );

  Widget _buildAnimeInfo({
    required AnimeDetails anime,
  }) {
    final studios = anime.studios.join(', ');
    final genres = anime.genres.join(', ');

    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoText(label: 'Genres: ', info: genres.isNotEmpty ? genres : 'N/A'),
        InfoText(
          label: 'Start date: ',
          info: formatDate(anime.startDate),
        ),
        InfoText(
          label: 'End date: ',
          info: formatDate(anime.endDate),
        ),
        InfoText(
          label: 'Episodes: ',
          info: anime.episodes?.toString() ?? 'Unknown',
        ),
        InfoText(
          label: 'Duration: ',
          info: anime.duration != null ? '${anime.duration} min' : 'Unknown',
        ),
        InfoText(label: 'Status: ', info: anime.status ?? 'Unknown'),
        InfoText(
          label: 'Studios: ',
          info: studios.isNotEmpty ? studios : 'N/A',
        ),
      ],
    );
  }

  Widget _buildAnimeImages({
    required List<AnimePicture> pictures,
  }) {
    if (pictures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          'Image Gallery',
          style: TextStyles.smallText,
        ),
        GridView.builder(
          itemCount: pictures.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final image = pictures[index].medium;
            final largeImage = pictures[index].large;
            return SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      NetworkImageView.routeName,
                      arguments: largeImage,
                    );
                  },
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
    required this.label,
    required this.info,
  });

  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: info,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
