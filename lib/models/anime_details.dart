import 'package:flutter/foundation.dart';

@immutable
class AnimeDetails {
  final int id;
  final String? titleRomaji;
  final String? titleEnglish;
  final String? titleNative;
  final String? coverImageUrl;
  final String? description;
  final int? episodes;
  final int? duration;
  final List<String> genres;
  final int? averageScore;
  final int? popularity;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final List<String> studios;
  final List<AnimePicture> pictures;

  const AnimeDetails({
    required this.id,
    this.titleRomaji,
    this.titleEnglish,
    this.titleNative,
    this.coverImageUrl,
    this.description,
    this.episodes,
    this.duration,
    required this.genres,
    this.averageScore,
    this.popularity,
    this.startDate,
    this.endDate,
    this.status,
    required this.studios,
    required this.pictures,
  });

  factory AnimeDetails.fromAniListJson(Map<String, dynamic> json) {
    final title = json['title'] ?? {};
    final start = json['startDate'];
    final end = json['endDate'];
    final studioNodes = json['studios']?['nodes'] ?? [];
    final picturesList = json['pictures'] ?? [];

    return AnimeDetails(
      id: json['id'],
      titleRomaji: title['romaji'],
      titleEnglish: title['english'],
      titleNative: title['native'],
      coverImageUrl: json['coverImage']?['large'],
      description: json['description'],
      episodes: json['episodes'],
      duration: json['duration'],
      genres: List<String>.from(json['genres'] ?? []),
      averageScore: json['averageScore'],
      popularity: json['popularity'],
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      status: json['status'],
      studios: List<String>.from(studioNodes.map((s) => s['name'] ?? '')),
      pictures: List<AnimePicture>.from(
        picturesList.map((pic) => AnimePicture.fromJson(pic)),
      ),
    );
  }

  static DateTime? _parseDate(Map<String, dynamic>? dateMap) {
    if (dateMap == null || dateMap['year'] == null) return null;
    return DateTime(
      dateMap['year'] ?? 0,
      dateMap['month'] ?? 1,
      dateMap['day'] ?? 1,
    );
  }
}

@immutable
class AnimePicture {
  final String medium;
  final String large;

  const AnimePicture({
    required this.medium,
    required this.large,
  });

  factory AnimePicture.fromJson(Map<String, dynamic> json) {
    return AnimePicture(
      medium: json['medium'] ?? '',
      large: json['large'] ?? '',
    );
  }
}
