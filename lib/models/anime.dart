import 'package:anime_world_tutorial/models/anime_info.dart';
import 'package:flutter/foundation.dart';

@immutable
class Anime {
  final int id;
  final String titleRomaji;
  final String? titleEnglish;
  final String? titleNative;
  final String imageUrl;

  const Anime({
    required this.id,
    required this.titleRomaji,
    this.titleEnglish,
    this.titleNative,
    required this.imageUrl,
  });

  factory Anime.fromAniListJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      titleRomaji: json['title']['romaji'] ?? '',
      titleEnglish: json['title']['english'],
      titleNative: json['title']['native'],
      imageUrl: json['coverImage']['large'] ?? '',
    );
  }

  get mainPicture => null;

}
