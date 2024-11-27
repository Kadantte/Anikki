import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'result.dart';

class TmdbVideos extends Equatable {
  final List<Result>? results;

  const TmdbVideos({this.results});

  factory TmdbVideos.fromMap(Map<String, dynamic> data) => TmdbVideos(
        results: (data['results'] as List<dynamic>?)
            ?.map((e) => Result.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'results': results?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TmdbVideos].
  factory TmdbVideos.fromJson(String data) {
    return TmdbVideos.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TmdbVideos] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [results];
}
