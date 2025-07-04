import 'package:flutter/cupertino.dart';

import '/common/widgets/network_image_view.dart';
import '/core/screens/error_screen.dart';
import '/models/anime_category.dart';
import '/screens/anime_details_screen.dart';
import '/screens/category_animes_screen.dart'; // Make sure this file exists
import '/screens/home_screen.dart';
import '/screens/view_all_animes_screen.dart';
import '/screens/view_all_seasonal_animes_screen.dart';

/// Handles dynamic routing in the app.
Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {

  /// Navigate to Anime Details by ID
    case AnimeDetailsScreen.routeName:
      final id = settings.arguments as int;
      return _cupertinoRoute(
        view: AnimeDetailsScreen(id: id),
      );

  /// Navigate to ranked/trending anime list
    case ViewAllAnimesScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final rankingType = arguments['rankingType'] as String;
      final label = arguments['label'] as String;
      return _cupertinoRoute(
        view: ViewAllAnimesScreen(
          rankingType: rankingType,
          label: label,
        ),
      );

  /// Navigate to seasonal anime list screen
    case ViewAllSeasonalAnimesScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final label = arguments['label'] as String;
      return _cupertinoRoute(
        view: ViewAllSeasonalAnimesScreen(
          label: label,
        ),
      );

  /// Navigate to category-based anime list
    case CategoryAnimesScreen.routeName:
      final category = settings.arguments as AnimeCategory;
      return _cupertinoRoute(
        view: CategoryAnimesScreen(
          category: category,
        ),
      );

  /// Navigate to home screen with optional tab index
    case HomeScreen.routeName:
      final index = settings.arguments as int?;
      return _cupertinoRoute(
        view: HomeScreen(
          index: index,
        ),
      );

  /// View full-screen network image
    case NetworkImageView.routeName:
      final imageUrl = settings.arguments as String;
      return _cupertinoRoute(
        view: NetworkImageView(
          url: imageUrl,
        ),
      );

  /// Default case: Unknown route
    default:
      return _cupertinoRoute(
        view: const ErrorScreen(
          error: 'The route you entered doesn\'t exist',
        ),
      );
  }
}

/// Helper to create Cupertino-style page routes.
CupertinoPageRoute _cupertinoRoute({required Widget view}) {
  return CupertinoPageRoute(
    builder: (_) => view,
  );
}
