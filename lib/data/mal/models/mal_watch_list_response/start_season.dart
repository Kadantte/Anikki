import 'dart:convert';

import 'package:anikki/data/data.dart';
import 'package:equatable/equatable.dart';

class StartSeason extends Equatable {
  final int? year;
  final String? season;

  const StartSeason({this.year, this.season});

  Enum$MediaSeason get anilistSeason => switch (season) {
        'spring' => Enum$MediaSeason.SPRING,
        'summer' => Enum$MediaSeason.SUMMER,
        'fall' => Enum$MediaSeason.FALL,
        'winter' => Enum$MediaSeason.WINTER,
        _ => Enum$MediaSeason.$unknown,
      };

  factory StartSeason.fromMap(Map<String, dynamic> data) => StartSeason(
        year: data['year'] as int?,
        season: data['season'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'year': year,
        'season': season,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StartSeason].
  factory StartSeason.fromJson(String data) {
    return StartSeason.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StartSeason] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [year, season];
}
