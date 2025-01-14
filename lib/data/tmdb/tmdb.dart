import 'package:anitomy/anitomy.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/tmdb/models/models.dart';

export 'helpers.dart';
export 'models/models.dart';

final tmdb = Tmdb();

class Tmdb {
  late final TMDB _tmdb;

  static String boxName = 'tmdb';

  int? get _animationGenreId => tmdbTvGenreList
      .firstWhereOrNull(
        (genre) => genre.name == 'Animation',
      )
      ?.id;

  Tmdb([
    TMDB? tmdb,
  ]) {
    _tmdb = tmdb ??
        TMDB(
          ApiKeys(
            dotenv.env['TMDB_ACCESS_KEY']!,
            dotenv.env['TMDB_READ_ACCESS_TOKEN']!,
          ),
        );
  }

  Future<TmdbTvDetails?> getDetails(String name) async {
    final box = await Hive.openBox(boxName);
    final cacheKey = 'details_$name';
    final cachedDetailsRaw = await box.get(cacheKey) as Map<dynamic, dynamic>?;

    if (cachedDetailsRaw != null && cachedDetailsRaw is Map<String, dynamic>) {
      return TmdbTvDetails.fromMap(cachedDetailsRaw);
    }

    final rawSearch = await _tmdb.v3.search.queryTvShows(
      name,
    ) as Map<String, dynamic>;
    final search = TmdbSearch.fromMap(rawSearch);

    final firstResult = search.results
        ?.where((e) => e.genreIds?.contains(_animationGenreId) == true)
        .firstOrNull;
    final firstResultId = firstResult?.id;

    if (firstResultId == null) return null;

    final seasonsToQuery = 15;

    final rawTmdbInfo = await _tmdb.v3.tv.getDetails(
      firstResultId,
      appendToResponse: [
        'images',
        'videos',
        for (final index in List.generate(seasonsToQuery, (index) => index))
          'season/$index',
      ].join(','),
      includeImageLanguage: 'en,ja,null',
    ) as Map<String, dynamic>;
    final tmdbSeasons = [
      for (final index in List.generate(seasonsToQuery, (index) => index))
        rawTmdbInfo['season/$index']
    ].whereType<Map>().toList();
    final tmdbInfo = TmdbTvDetails.fromMap({
      ...rawTmdbInfo,
      'tmdbSeasons': tmdbSeasons,
    });

    box.put(cacheKey, tmdbInfo.toMap());

    return tmdbInfo;
  }

  Future<Media> hydrateMediaWithTmdb(
    Media initialMedia, [
    String? searchTitle,
  ]) async {
    try {
      if (initialMedia.title == null) return initialMedia;

      final parsedTitle = Anitomy(
        inputString: initialMedia.title!,
      );
      final title = searchTitle ?? parsedTitle.title ?? initialMedia.title!;

      final tmdbInfo = await getDetails(sanitizeName(title));

      return initialMedia.copyWith(
        tmdbInfo: tmdbInfo,
      );
    } catch (e) {
      return initialMedia;
    }
  }
}
