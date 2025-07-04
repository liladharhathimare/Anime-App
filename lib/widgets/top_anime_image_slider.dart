import 'package:anime_world_tutorial/screens/anime_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/constants/app_colors.dart';
import '/models/anime.dart';

class TopAnimesImageSlider extends StatefulWidget {
  const TopAnimesImageSlider({
    super.key,
    required this.animes,
  });

  final Iterable<Anime> animes;

  @override
  State<TopAnimesImageSlider> createState() => _TopAnimesImageSliderState();
}

class _TopAnimesImageSliderState extends State<TopAnimesImageSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animesList = widget.animes.toList();

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: animesList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final anime = animesList[index];
                return _TopAnimePicture(anime: anime);
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSmoothIndicator(
            activeIndex: _currentPageIndex,
            count: animesList.length,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                borderRadius: BorderRadius.circular(8.0),
                width: 28.0,
                height: 8.0,
                color: AppColors.blueColor,
              ),
              dotDecoration: DotDecoration(
                borderRadius: BorderRadius.circular(8.0),
                width: 28.0,
                height: 8.0,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopAnimePicture extends StatelessWidget {
  const _TopAnimePicture({
    required this.anime,
  });

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AnimeDetailsScreen(id: anime.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              anime.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
      ),
    );
  }
}

