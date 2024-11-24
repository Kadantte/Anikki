import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'crew.dart';
import 'guest_star.dart';

class Episode extends Equatable {
  final String? airDate;
  final int? episodeNumber;
  final String? episodeType;
  final int? id;
  final String? name;
  final String? overview;
  final String? productionCode;
  final int? runtime;
  final int? seasonNumber;
  final int? showId;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;
  final List<Crew>? crew;
  final List<GuestStar>? guestStars;

  const Episode({
    this.airDate,
    this.episodeNumber,
    this.episodeType,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.runtime,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.crew,
    this.guestStars,
  });

  factory Episode.fromMap(Map<String, dynamic> data) => Episode(
        airDate: data['air_date'] as String?,
        episodeNumber: data['episode_number'] as int?,
        episodeType: data['episode_type'] as String?,
        id: data['id'] as int?,
        name: data['name'] as String?,
        overview: data['overview'] as String?,
        productionCode: data['production_code'] as String?,
        runtime: data['runtime'] as int?,
        seasonNumber: data['season_number'] as int?,
        showId: data['show_id'] as int?,
        stillPath: data['still_path'] as String?,
        voteAverage: (data['vote_average'] as num?)?.toDouble(),
        voteCount: data['vote_count'] as int?,
        crew: (data['crew'] as List<dynamic>?)
            ?.map((e) => Crew.fromMap(e as Map<String, dynamic>))
            .toList(),
        guestStars: (data['guest_stars'] as List<dynamic>?)
            ?.map((e) => GuestStar.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'air_date': airDate,
        'episode_number': episodeNumber,
        'episode_type': episodeType,
        'id': id,
        'name': name,
        'overview': overview,
        'production_code': productionCode,
        'runtime': runtime,
        'season_number': seasonNumber,
        'show_id': showId,
        'still_path': stillPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'crew': crew?.map((e) => e.toMap()).toList(),
        'guest_stars': guestStars?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Episode].
  factory Episode.fromJson(String data) {
    return Episode.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Episode] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      airDate,
      episodeNumber,
      episodeType,
      id,
      name,
      overview,
      productionCode,
      runtime,
      seasonNumber,
      showId,
      stillPath,
      voteAverage,
      voteCount,
      crew,
      guestStars,
    ];
  }
}
