import 'dart:convert';

import 'package:equatable/equatable.dart';

class ListStatus extends Equatable {
  final String? status;
  final int? score;
  final int? numEpisodesWatched;
  final bool? isRewatching;
  final String? updatedAt;
  final String? startDate;

  const ListStatus({
    this.status,
    this.score,
    this.numEpisodesWatched,
    this.isRewatching,
    this.updatedAt,
    this.startDate,
  });

  factory ListStatus.fromMap(Map<String, dynamic> data) => ListStatus(
        status: data['status'] as String?,
        score: data['score'] as int?,
        numEpisodesWatched: data['num_episodes_watched'] as int?,
        isRewatching: data['is_rewatching'] as bool?,
        updatedAt: data['updated_at'] as String?,
        startDate: data['start_date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'score': score,
        'num_episodes_watched': numEpisodesWatched,
        'is_rewatching': isRewatching,
        'updated_at': updatedAt,
        'start_date': startDate,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ListStatus].
  factory ListStatus.fromJson(String data) {
    return ListStatus.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ListStatus] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      status,
      score,
      numEpisodesWatched,
      isRewatching,
      updatedAt,
      startDate,
    ];
  }
}
