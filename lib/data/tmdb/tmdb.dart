import 'package:anitomy/anitomy.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/tmdb/models/models.dart';

class Tmdb {
  late final TMDB _tmdb;

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
    final rawSearch = await _tmdb.v3.search.queryTvShows(
      name,
    ) as Map<String, dynamic>;
    final search = TmdbSearch.fromMap(rawSearch);

    final firstResult = search.results
        ?.where((e) => e.genreIds?.contains(_animationGenreId) == true)
        .firstOrNull;
    final firstResultId = firstResult?.id;

    if (firstResultId == null) return null;

    final rawTmdbInfo = await _tmdb.v3.tv.getDetails(
      firstResultId,
      appendToResponse: 'images,',
      includeImageLanguage: 'en,jp,null',
    ) as Map<String, dynamic>;
    final tmdbInfo = TmdbTvDetails.fromMap(rawTmdbInfo);

    return tmdbInfo;
  }

  Future<Media> hydrateMediaWithTmdb(Media initialMedia) async {
    if (initialMedia.title == null) return initialMedia;

    final parsedTitle = Anitomy(inputString: initialMedia.title!);
    final title = parsedTitle.title ?? initialMedia.title!;

    final tmdbInfo = await getDetails(title);

    return initialMedia.copyWith(
      tmdbInfo: tmdbInfo,
    );
  }
}