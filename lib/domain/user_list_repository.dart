import 'package:collection/collection.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

/// Repository that handles user anime list on providers (for now only Anilist)
class UserListRepository {
  const UserListRepository({
    required this.anilist,
    required this.tmdb,
    required this.mal,
  });

  /// The [Anilist] object to use to interact with Anilist.
  final Anilist anilist;

  /// The [Mal] object to use to interact with MyAnimeList.
  final Mal mal;

  /// The [TMDB] object to use to interact with TMDB.
  final Tmdb tmdb;

  Enum$MediaListStatus? _getWatchedEntryStatus(
    WatchList watchList,
    Media media,
    int episode,
  ) {
    Enum$MediaListStatus? status;

    final isCompleted = watchList.getCompletedEntry(media) != null;
    final isPlanning = watchList.getPlanningEntry(media) != null;

    if (isCompleted && episode == 1) {
      status = Enum$MediaListStatus.REPEATING;
    } else if (isPlanning && episode == 1) {
      status = Enum$MediaListStatus.CURRENT;
    }

    return status;
  }

  /// Mark a [Media] as watched for the given episode.
  /// If `episode == 1`, will set the status of the entry to `Current`.
  Future<bool> watchedEntry({
    required int episode,
    required Media media,
    required WatchListProvider provider,
    required WatchList watchList,
  }) async {
    switch (provider) {
      case WatchListProvider.anilist:
        if (media.anilistInfo == null) return false;
        if (media.anilistInfo!.id == 0) return false;

        return anilist.updateEntry(
          episode: episode,
          mediaId: media.anilistInfo!.id,
          status: _getWatchedEntryStatus(watchList, media, episode),
        );
      case WatchListProvider.mal:
        if (media.malId == null) return false;

        final status = switch (_getWatchedEntryStatus(
          watchList,
          media,
          episode,
        )) {
          Enum$MediaListStatus.CURRENT ||
          Enum$MediaListStatus.REPEATING =>
            'watching',
          Enum$MediaListStatus.PLANNING => 'plan_to_watch',
          Enum$MediaListStatus.COMPLETED => 'completed',
          Enum$MediaListStatus.DROPPED => 'dropped',
          Enum$MediaListStatus.PAUSED => 'on_hold',
          _ => null,
        };

        return mal.updateEntry(
          episode: episode,
          mediaId: media.malId!,
          status: status,
        );
      case WatchListProvider.kitsu:
        throw UnimplementedError();
    }
  }

  Future<void> removeEntry({
    required Media media,
    required WatchListProvider provider,
  }) async {
    switch (provider) {
      case WatchListProvider.anilist:
        final mediaId = media.anilistInfo?.id;

        if (mediaId == null || mediaId == 0) return;

        await anilist.updateEntry(
          mediaId: mediaId,
          status: Enum$MediaListStatus.DROPPED,
        );
      case WatchListProvider.mal:
        if (media.malId == null) return;

        await mal.updateEntry(
          mediaId: media.malId!,
          status: 'dropped',
        );
      case WatchListProvider.kitsu:
        throw UnimplementedError();
    }
  }

  /// Returns the watch lists of the currently authenticated user on `provider`
  Future<WatchList?> getList(WatchListProvider provider) async {
    return switch (provider) {
      WatchListProvider.anilist => WatchList.fromAnilistWatchList(
          await anilist.getWatchLists(),
        ),
      WatchListProvider.mal => await mal.getWatchList(),
      WatchListProvider.kitsu => throw UnimplementedError(),
    };
  }

  Future<List<MediaListEntry>> getContinueList(
    WatchList watchList,
  ) async {
    final entries = {
      ...watchList.current,
      ...watchList.repeating,
    }.where(
      (element) {
        final progress = element.progress ?? 0;
        final nextEpisode = element.media.nextAiringEpisode;
        final nbEpisodes = element.media.numberOfEpisodes ?? double.infinity;

        return nextEpisode != null
            ? progress < nextEpisode - 1
            : progress < nbEpisodes;
      },
    ).sorted(
      (a, b) => (b.updatedAt ?? 0).compareTo(a.updatedAt ?? 0),
    );

    return [
      for (final entry in entries)
        MediaListEntry(
          updatedAt: entry.updatedAt,
          progress: entry.progress,
          media: await tmdb.hydrateMediaWithTmdb(
            entry.media,
          ),
        ),
    ];
  }

  Future<List<MediaListEntry>> getStartList(
    WatchList watchList,
  ) async {
    final season = currentSeason();
    final year = DateTime.now().year;
    final planningList = watchList.planning;

    final seasonEntries = planningList.where((element) {
      return element.media.season == season &&
          element.media.seasonYear == year &&
          element.media.nextAiringEpisode != 1 &&
          element.progress == 0;
    });

    final entries =
        seasonEntries.isNotEmpty ? seasonEntries : watchList.planning;

    return [
      for (final entry in entries)
        MediaListEntry(
          updatedAt: entry.updatedAt,
          progress: entry.progress,
          media: await tmdb.hydrateMediaWithTmdb(
            entry.media,
          ),
        ),
    ];
  }

  Future<WatchList> toggleFavourite({
    required WatchList watchList,
    required Media media,
    required WatchListProvider provider,
  }) async {
    switch (provider) {
      case WatchListProvider.anilist:
        try {
          final mediaId = media.anilistInfo?.id;

          if (mediaId == null) return watchList;

          await anilist.toggleFavourite(mediaId: mediaId);

          MediaListEntry updateFavourite(MediaListEntry entry) {
            if (entry.media.anilistInfo?.id != mediaId) return entry;

            return entry.copyWith(
              media: entry.media.copyWith(
                anilistInfo: entry.media.anilistInfo?.copyWith(
                  isFavourite: entry.media.anilistInfo?.isFavourite == null
                      ? true
                      : !(entry.media.anilistInfo?.isFavourite ?? false),
                ),
              ),
            );
          }

          return watchList.copyWith(
            completed: watchList.completed.map(updateFavourite).toList(),
            current: watchList.current.map(updateFavourite).toList(),
            dropped: watchList.dropped.map(updateFavourite).toList(),
            paused: watchList.paused.map(updateFavourite).toList(),
            planning: watchList.planning.map(updateFavourite).toList(),
            repeating: watchList.repeating.map(updateFavourite).toList(),
          );
        } catch (e) {
          throw AnilistToggleFavouriteException(
            error: e.toString(),
          );
        }
      case WatchListProvider.mal:
        return watchList;
      case WatchListProvider.kitsu:
        throw UnimplementedError();
    }
  }
}
