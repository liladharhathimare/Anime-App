import 'package:flutter/foundation.dart' show immutable;

import '/models/anime.dart';

@immutable
class AnimeInfo {
  final List<Anime> animes;

  const AnimeInfo({
    required this.animes,
  });

  factory AnimeInfo.fromJson(Map<String, dynamic> json) {
    final List<dynamic> mediaList = json['data']['Page']['media'];

    final List<Anime> animeItems = mediaList
        .map((item) => Anime.fromAniListJson(item))
        .toList();

    return AnimeInfo(
      animes: animeItems,
    );
  }
}
