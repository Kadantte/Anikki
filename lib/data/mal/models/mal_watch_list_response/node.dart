import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'alternative_titles.dart';
import 'broadcast.dart';
import 'genre.dart';
import 'main_picture.dart';
import 'start_season.dart';
import 'studio.dart';

class Node extends Equatable {
  final int? id;
  final String? title;
  final MainPicture? mainPicture;
  final AlternativeTitles? alternativeTitles;
  final String? startDate;
  final String? endDate;
  final String? synopsis;
  final double? mean;
  final int? rank;
  final int? popularity;
  final int? numListUsers;
  final int? numScoringUsers;
  final String? nsfw;
  final List<Genre>? genres;
  final String? createdAt;
  final String? updatedAt;
  final String? mediaType;
  final String? status;
  final int? numEpisodes;
  final StartSeason? startSeason;
  final Broadcast? broadcast;
  final String? source;
  final int? averageEpisodeDuration;
  final String? rating;
  final List<Studio>? studios;

  const Node({
    this.id,
    this.title,
    this.mainPicture,
    this.alternativeTitles,
    this.startDate,
    this.endDate,
    this.synopsis,
    this.mean,
    this.rank,
    this.popularity,
    this.numListUsers,
    this.numScoringUsers,
    this.nsfw,
    this.genres,
    this.createdAt,
    this.updatedAt,
    this.mediaType,
    this.status,
    this.numEpisodes,
    this.startSeason,
    this.broadcast,
    this.source,
    this.averageEpisodeDuration,
    this.rating,
    this.studios,
  });

  factory Node.fromMap(Map<String, dynamic> data) => Node(
        id: data['id'] as int?,
        title: data['title'] as String?,
        mainPicture: data['main_picture'] == null
            ? null
            : MainPicture.fromMap(data['main_picture'] as Map<String, dynamic>),
        alternativeTitles: data['alternative_titles'] == null
            ? null
            : AlternativeTitles.fromMap(
                data['alternative_titles'] as Map<String, dynamic>),
        startDate: data['start_date'] as String?,
        endDate: data['end_date'] as String?,
        synopsis: data['synopsis'] as String?,
        mean: (data['mean'] as num?)?.toDouble(),
        rank: data['rank'] as int?,
        popularity: data['popularity'] as int?,
        numListUsers: data['num_list_users'] as int?,
        numScoringUsers: data['num_scoring_users'] as int?,
        nsfw: data['nsfw'] as String?,
        genres: (data['genres'] as List<dynamic>?)
            ?.map((e) => Genre.fromMap(e as Map<String, dynamic>))
            .toList(),
        createdAt: data['created_at'] as String?,
        updatedAt: data['updated_at'] as String?,
        mediaType: data['media_type'] as String?,
        status: data['status'] as String?,
        numEpisodes: data['num_episodes'] as int?,
        startSeason: data['start_season'] == null
            ? null
            : StartSeason.fromMap(data['start_season'] as Map<String, dynamic>),
        broadcast: data['broadcast'] == null
            ? null
            : Broadcast.fromMap(data['broadcast'] as Map<String, dynamic>),
        source: data['source'] as String?,
        averageEpisodeDuration: data['average_episode_duration'] as int?,
        rating: data['rating'] as String?,
        studios: (data['studios'] as List<dynamic>?)
            ?.map((e) => Studio.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'main_picture': mainPicture?.toMap(),
        'alternative_titles': alternativeTitles?.toMap(),
        'start_date': startDate,
        'end_date': endDate,
        'synopsis': synopsis,
        'mean': mean,
        'rank': rank,
        'popularity': popularity,
        'num_list_users': numListUsers,
        'num_scoring_users': numScoringUsers,
        'nsfw': nsfw,
        'genres': genres?.map((e) => e.toMap()).toList(),
        'created_at': createdAt,
        'updated_at': updatedAt,
        'media_type': mediaType,
        'status': status,
        'num_episodes': numEpisodes,
        'start_season': startSeason?.toMap(),
        'broadcast': broadcast?.toMap(),
        'source': source,
        'average_episode_duration': averageEpisodeDuration,
        'rating': rating,
        'studios': studios?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Node].
  factory Node.fromJson(String data) {
    return Node.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Node] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      mainPicture,
      alternativeTitles,
      startDate,
      endDate,
      synopsis,
      mean,
      rank,
      popularity,
      numListUsers,
      numScoringUsers,
      nsfw,
      genres,
      createdAt,
      updatedAt,
      mediaType,
      status,
      numEpisodes,
      startSeason,
      broadcast,
      source,
      averageEpisodeDuration,
      rating,
      studios,
    ];
  }
}
