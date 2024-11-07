import 'dart:convert';

import 'package:anitomy/anitomy.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/helpers/anilist/anilist_utils.dart';
import 'package:anikki/data/data.dart';

part 'media_episodes.dart';
part 'media_images.dart';

sealed class IMedia extends Equatable {
  const IMedia({
    this.anilistInfo,
    this.tmdbInfo,
  });

  final Fragment$media? anilistInfo;
  final TmdbTvDetails? tmdbInfo;

  String? get title;
}

final class Media extends IMedia with MediaImages, MediaEpisodes {
  const Media({
    super.anilistInfo,
    super.tmdbInfo,
  });

  @override
  String? get title =>
      anilistInfo?.title?.userPreferred ??
      anilistInfo?.title?.romaji ??
      tmdbInfo?.name ??
      anilistInfo?.title?.english;

  String? get originalTitle =>
      anilistInfo?.title?.native ?? tmdbInfo?.originalName;

  @override
  List<Object?> get props => [anilistInfo, tmdbInfo];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'anilistInfo': anilistInfo?.toJson(),
      'tmdbInfo': tmdbInfo?.toJson(),
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      anilistInfo: Fragment$media.fromJson(
        map['anilistInfo'] as Map<String, dynamic>,
      ),
      tmdbInfo: TmdbTvDetails.fromJson(
        map['tmdbInfo'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Media.fromJson(String source) =>
      Media.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  Media copyWith({
    Fragment$media? anilistInfo,
    TmdbTvDetails? tmdbInfo,
  }) {
    return Media(
      anilistInfo: anilistInfo ?? this.anilistInfo,
      tmdbInfo: tmdbInfo ?? this.tmdbInfo,
    );
  }
}
