import 'package:collection/collection.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

class AnilistUtils {
  static AnilistWatchListEntry? getListEntry(
    List<AnilistWatchListEntry> entries,
    Media media,
  ) {
    return entries.firstWhereOrNull(
      (element) => element.media?.id == media.anilistInfo.id,
    );
  }

  static AnilistWatchListEntry? getCurrentEntry(
    AnilistWatchList watchList,
    Media media,
  ) {
    return AnilistUtils.getListEntry(watchList.current, media) ??
        AnilistUtils.getListEntry(watchList.repeating, media) ??
        AnilistUtils.getListEntry(watchList.paused, media) ??
        AnilistUtils.getListEntry(watchList.dropped, media);
  }

  static AnilistWatchListEntry? getWatchListEntry(
    AnilistWatchList watchList,
    Media media,
  ) {
    return AnilistUtils.getListEntry(watchList.current, media) ??
        AnilistUtils.getListEntry(watchList.repeating, media) ??
        AnilistUtils.getListEntry(watchList.paused, media) ??
        AnilistUtils.getListEntry(watchList.completed, media) ??
        AnilistUtils.getListEntry(watchList.planning, media) ??
        AnilistUtils.getListEntry(watchList.dropped, media);
  }

  static AnilistWatchListEntry? getCompletedEntry(
    AnilistWatchList watchList,
    Media media,
  ) {
    return AnilistUtils.getListEntry(watchList.completed, media);
  }

  static Fragment$media getEmptyMedia({
    int id = 0,
    String? title,
  }) =>
      Fragment$media(
        id: id,
        isFavourite: false,
        title:
            title == null ? null : Fragment$media$title(userPreferred: title),
      );

  static int? getEpisodeNumberFromEpisodeTItle(String? title) => int.tryParse(
        title?.split(' ').elementAtOrNull(1) ?? '',
      );
}
