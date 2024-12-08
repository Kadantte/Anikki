import 'dart:convert';
import 'dart:math';

import 'package:anitomy/anitomy.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/data/data.dart';

part 'media_episodes.dart';
part 'media_images.dart';

sealed class IMedia extends Equatable {
  const IMedia({
    this.anilistInfo,
    this.malInfo,
    this.tmdbInfo,
  });

  final Fragment$media? anilistInfo;
  final TmdbTvDetails? tmdbInfo;
  final MalMediaInfo? malInfo;

  String? get title;
}

final class Media extends IMedia with MediaImages, MediaEpisodes {
  const Media({
    super.anilistInfo,
    super.tmdbInfo,
    super.malInfo,
  });

  bool get isEmpty => props.every((prop) => prop == null);
  bool get isNotEmpty => !isEmpty;

  int get id =>
      anilistInfo?.id ??
      malInfo?.id ??
      tmdbInfo?.id ??
      Random().nextInt(100000);

  int? get malId => anilistInfo?.idMal ?? malInfo?.id;

  @override
  String? get title =>
      anilistInfo?.title?.userPreferred ??
      anilistInfo?.title?.romaji ??
      malInfo?.title ??
      tmdbInfo?.name ??
      anilistInfo?.title?.english;

  String? get originalTitle =>
      anilistInfo?.title?.native ??
      malInfo?.alternativeTitles?.ja ??
      tmdbInfo?.originalName;

  List<String>? get synonyms => {
        title,

        /// Full english name
        anilistInfo?.title?.english ?? malInfo?.alternativeTitles?.en,

        /// Native name (probably in Japanese)
        originalTitle,

        /// Romaji name
        anilistInfo?.title?.romaji,

        /// All the other synonyms
        ...(anilistInfo?.synonyms ?? []),
        ...(malInfo?.alternativeTitles?.synonyms ?? []),
        tmdbInfo?.name,
      }.whereType<String>().toList();

  Enum$MediaSeason? get season =>
      anilistInfo?.season ?? malInfo?.startSeason?.anilistSeason;

  int? get seasonYear => anilistInfo?.seasonYear ?? malInfo?.startSeason?.year;

  List<String>? get genres => (anilistInfo?.genres ??
          malInfo?.genres?.map((genre) => genre.name) ??
          tmdbInfo?.genres?.map((genre) => genre.name))
      ?.whereType<String>()
      .toList();

  Enum$MediaFormat? get format =>
      anilistInfo?.format ??
      switch (malInfo?.mediaType) {
        'tv' => Enum$MediaFormat.TV,
        'movie' => Enum$MediaFormat.MOVIE,
        'ova' => Enum$MediaFormat.OVA,
        'ona' => Enum$MediaFormat.ONA,
        'special' => Enum$MediaFormat.SPECIAL,
        _ => Enum$MediaFormat.$unknown,
      };

  String? get youtubeId =>
      tmdbInfo?.tmdbVideos?.results
          ?.firstWhereOrNull(
            (video) =>
                video.iso6391 == 'en' &&
                video.site?.toLowerCase() == 'youtube' &&
                video.type?.toLowerCase() == 'trailer',
          )
          ?.key ??
      (anilistInfo?.trailer?.site?.toLowerCase() == 'youtube'
          ? anilistInfo?.trailer?.id
          : null);

  @override
  List<Object?> get props => [
        malInfo,
        anilistInfo,
        tmdbInfo,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'anilistInfo': anilistInfo?.toJson(),
      'malInfo': malInfo?.toJson(),
      'tmdbInfo': tmdbInfo?.toJson(),
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      anilistInfo: Fragment$media.fromJson(
        map['anilistInfo'] as Map<String, dynamic>,
      ),
      malInfo: MalMediaInfo.fromMap(
        map['malInfo'] as Map<String, dynamic>,
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
    MalMediaInfo? malInfo,
    TmdbTvDetails? tmdbInfo,
  }) {
    return Media(
      anilistInfo: anilistInfo ?? this.anilistInfo,
      malInfo: malInfo ?? this.malInfo,
      tmdbInfo: tmdbInfo ?? this.tmdbInfo,
    );
  }
}
