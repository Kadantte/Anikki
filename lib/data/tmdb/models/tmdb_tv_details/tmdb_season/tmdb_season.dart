import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'episode.dart';

class TmdbSeason extends Equatable {
  final String? id;
  final String? airDate;
  final List<Episode>? episodes;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;
  final double? voteAverage;

  const TmdbSeason({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
    this.voteAverage,
  });

  factory TmdbSeason.fromMap(Map<String, dynamic> data) => TmdbSeason(
        id: data['_id'] as String?,
        airDate: data['air_date'] as String?,
        episodes: (data['episodes'] as List<dynamic>?)
            ?.map((e) => Episode.fromMap(e as Map<String, dynamic>))
            .toList(),
        name: data['name'] as String?,
        overview: data['overview'] as String?,
        posterPath: data['poster_path'] as String?,
        seasonNumber: data['season_number'] as int?,
        voteAverage: (data['vote_average'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'air_date': airDate,
        'episodes': episodes?.map((e) => e.toMap()).toList(),
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber,
        'vote_average': voteAverage,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TmdbSeason].
  factory TmdbSeason.fromJson(String data) {
    return TmdbSeason.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TmdbSeason] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      airDate,
      episodes,
      name,
      overview,
      posterPath,
      seasonNumber,
      voteAverage,
    ];
  }
}
