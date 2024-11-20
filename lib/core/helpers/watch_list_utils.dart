import 'package:anikki/core/core.dart';

class WatchListUtils {
  static MediaListEntry? getCompletedEntry(
    Map<WatchListProvider, WatchList> watchLists,
    Media media,
  ) {
    for (final watchList in watchLists.values) {
      final entry = watchList.getCompletedEntry(media);
      if (entry == null) continue;

      return entry;
    }

    return null;
  }

  static MediaListEntry? getCurrentEntry(
    Map<WatchListProvider, WatchList> watchLists,
    Media media,
  ) {
    for (final watchList in watchLists.values) {
      final entry = watchList.getCurrentEntry(media);
      if (entry == null) continue;

      return entry;
    }

    return null;
  }

  static MediaListEntry? getPlanningEntry(
    Map<WatchListProvider, WatchList> watchLists,
    Media media,
  ) {
    for (final watchList in watchLists.values) {
      final entry = watchList.getPlanningEntry(media);
      if (entry == null) continue;

      return entry;
    }

    return null;
  }

  static MediaListEntry? getWatchListEntry(
    Map<WatchListProvider, WatchList> watchLists,
    Media media,
  ) {
    for (final watchList in watchLists.values) {
      final entry = watchList.getWatchListEntry(media);
      if (entry == null) continue;

      return entry;
    }

    return null;
  }
}
