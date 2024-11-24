import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:anikki/data/tmdb/models/models.dart';

import 'genre.dart';
import 'last_episode_to_air.dart';
import 'network.dart';
import 'next_episode_to_air.dart';
import 'production_company.dart';
import 'production_country.dart';
import 'season.dart';
import 'spoken_language.dart';

class TmdbTvDetails extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final List<dynamic>? createdBy;
  final List<int>? episodeRunTime;
  final String? firstAirDate;
  final List<Genre>? genres;
  final String? homepage;
  final int? id;
  final bool? inProduction;
  final List<String>? languages;
  final String? lastAirDate;
  final LastEpisodeToAir? lastEpisodeToAir;
  final String? name;
  final NextEpisodeToAir? nextEpisodeToAir;
  final List<Network>? networks;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final List<Season>? seasons;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? type;
  final double? voteAverage;
  final int? voteCount;
  final TmdbTvImages? images;
  final List<TmdbSeason>? tmdbSeasons;

  const TmdbTvDetails({
    this.adult,
    this.backdropPath,
    this.createdBy,
    this.episodeRunTime,
    this.firstAirDate,
    this.genres,
    this.homepage,
    this.id,
    this.inProduction,
    this.languages,
    this.lastAirDate,
    this.lastEpisodeToAir,
    this.name,
    this.nextEpisodeToAir,
    this.networks,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.seasons,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.type,
    this.voteAverage,
    this.voteCount,
    this.images,
    this.tmdbSeasons,
  });

  factory TmdbTvDetails.fromMap(Map<String, dynamic> data) => TmdbTvDetails(
        images: data['images'] == null
            ? null
            : TmdbTvImages.fromMap(data['images'] as Map<String, dynamic>),
        adult: data['adult'] as bool?,
        backdropPath: data['backdrop_path'] as String?,
        createdBy: data['created_by'] as List<dynamic>?,
        episodeRunTime: data['episode_run_time']?.cast<int>() as List<int>?,
        firstAirDate: data['first_air_date'] as String?,
        genres: (data['genres'] as List<dynamic>?)
            ?.map((e) => Genre.fromMap(e as Map<String, dynamic>))
            .toList(),
        homepage: data['homepage'] as String?,
        id: data['id']?.toInt() as int?,
        inProduction: data['in_production'] as bool?,
        languages: data['languages']?.cast<String>() as List<String>?,
        lastAirDate: data['last_air_date'] as String?,
        lastEpisodeToAir: data['last_episode_to_air'] == null
            ? null
            : LastEpisodeToAir.fromMap(
                data['last_episode_to_air'] as Map<String, dynamic>),
        name: data['name'] as String?,
        nextEpisodeToAir: data['next_episode_to_air'] == null
            ? null
            : NextEpisodeToAir.fromMap(
                data['next_episode_to_air'] as Map<String, dynamic>),
        networks: (data['networks'] as List<dynamic>?)
            ?.map((e) => Network.fromMap(e as Map<String, dynamic>))
            .toList(),
        numberOfEpisodes: data['number_of_episodes']?.toInt() as int?,
        numberOfSeasons: data['number_of_seasons']?.toInt() as int?,
        originCountry: data['origin_country']?.cast<String>() as List<String>?,
        originalLanguage: data['original_language'] as String?,
        originalName: data['original_name'] as String?,
        overview: data['overview'] as String?,
        popularity: (data['popularity'] as num?)?.toDouble(),
        posterPath: data['poster_path'] as String?,
        productionCompanies: (data['production_companies'] as List<dynamic>?)
            ?.map((e) => ProductionCompany.fromMap(e as Map<String, dynamic>))
            .toList(),
        productionCountries: (data['production_countries'] as List<dynamic>?)
            ?.map((e) => ProductionCountry.fromMap(e as Map<String, dynamic>))
            .toList(),
        seasons: (data['seasons'] as List<dynamic>?)
            ?.map((e) => Season.fromMap(e as Map<String, dynamic>))
            .toList(),
        spokenLanguages: (data['spoken_languages'] as List<dynamic>?)
            ?.map((e) => SpokenLanguage.fromMap(e as Map<String, dynamic>))
            .toList(),
        status: data['status'] as String?,
        tagline: data['tagline'] as String?,
        type: data['type'] as String?,
        voteAverage: (data['vote_average'] as num?)?.toDouble(),
        voteCount: data['vote_count']?.toInt() as int?,
        tmdbSeasons: data['tmdbSeasons'] != null
            ? List<TmdbSeason>.from(
                (data['tmdbSeasons'] as List).map<TmdbSeason?>(
                  (x) => TmdbSeason.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'backdropPath': backdropPath,
      'createdBy': createdBy,
      'episodeRunTime': episodeRunTime,
      'firstAirDate': firstAirDate,
      'genres': genres?.map((x) => x.toMap()).toList(),
      'homepage': homepage,
      'id': id,
      'inProduction': inProduction,
      'languages': languages,
      'lastAirDate': lastAirDate,
      'lastEpisodeToAir': lastEpisodeToAir?.toMap(),
      'name': name,
      'nextEpisodeToAir': nextEpisodeToAir?.toMap(),
      'networks': networks?.map((x) => x.toMap()).toList(),
      'numberOfEpisodes': numberOfEpisodes,
      'numberOfSeasons': numberOfSeasons,
      'originCountry': originCountry,
      'originalLanguage': originalLanguage,
      'originalName': originalName,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'productionCompanies':
          productionCompanies?.map((x) => x.toMap()).toList(),
      'productionCountries':
          productionCountries?.map((x) => x.toMap()).toList(),
      'seasons': seasons?.map((x) => x.toMap()).toList(),
      'spokenLanguages': spokenLanguages?.map((x) => x.toMap()).toList(),
      'status': status,
      'tagline': tagline,
      'type': type,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'images': images?.toMap(),
      'tmdbSeasons': tmdbSeasons?.map((x) => x.toMap()).toList(),
    };
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TmdbTvDetails].
  factory TmdbTvDetails.fromJson(String data) {
    return TmdbTvDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TmdbTvDetails] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      adult,
      backdropPath,
      createdBy,
      episodeRunTime,
      firstAirDate,
      genres,
      homepage,
      id,
      inProduction,
      languages,
      lastAirDate,
      lastEpisodeToAir,
      name,
      nextEpisodeToAir,
      networks,
      numberOfEpisodes,
      numberOfSeasons,
      originCountry,
      originalLanguage,
      originalName,
      overview,
      popularity,
      posterPath,
      productionCompanies,
      productionCountries,
      seasons,
      spokenLanguages,
      status,
      tagline,
      type,
      voteAverage,
      voteCount,
      images,
      tmdbSeasons,
    ];
  }

  TmdbTvDetails copyWith({
    bool? adult,
    String? backdropPath,
    List<dynamic>? createdBy,
    List<int>? episodeRunTime,
    String? firstAirDate,
    List<Genre>? genres,
    String? homepage,
    int? id,
    bool? inProduction,
    List<String>? languages,
    String? lastAirDate,
    LastEpisodeToAir? lastEpisodeToAir,
    String? name,
    NextEpisodeToAir? nextEpisodeToAir,
    List<Network>? networks,
    int? numberOfEpisodes,
    int? numberOfSeasons,
    List<String>? originCountry,
    String? originalLanguage,
    String? originalName,
    String? overview,
    double? popularity,
    String? posterPath,
    List<ProductionCompany>? productionCompanies,
    List<ProductionCountry>? productionCountries,
    List<Season>? seasons,
    List<SpokenLanguage>? spokenLanguages,
    String? status,
    String? tagline,
    String? type,
    double? voteAverage,
    int? voteCount,
    TmdbTvImages? images,
    List<TmdbSeason>? tmdbSeasons,
  }) {
    return TmdbTvDetails(
      adult: adult ?? this.adult,
      backdropPath: backdropPath ?? this.backdropPath,
      createdBy: createdBy ?? this.createdBy,
      episodeRunTime: episodeRunTime ?? this.episodeRunTime,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      genres: genres ?? this.genres,
      homepage: homepage ?? this.homepage,
      id: id ?? this.id,
      inProduction: inProduction ?? this.inProduction,
      languages: languages ?? this.languages,
      lastAirDate: lastAirDate ?? this.lastAirDate,
      lastEpisodeToAir: lastEpisodeToAir ?? this.lastEpisodeToAir,
      name: name ?? this.name,
      nextEpisodeToAir: nextEpisodeToAir ?? this.nextEpisodeToAir,
      networks: networks ?? this.networks,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      originCountry: originCountry ?? this.originCountry,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalName: originalName ?? this.originalName,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      seasons: seasons ?? this.seasons,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      type: type ?? this.type,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      images: images ?? this.images,
      tmdbSeasons: tmdbSeasons ?? this.tmdbSeasons,
    );
  }
}
