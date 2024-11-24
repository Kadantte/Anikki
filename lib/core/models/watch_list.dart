import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

class WatchList extends Equatable {
  const WatchList({
    required this.provider,
    this.completed = const [],
    this.current = const [],
    this.dropped = const [],
    this.paused = const [],
    this.planning = const [],
    this.repeating = const [],
  });

  final WatchListProvider provider;

  final List<MediaListEntry> completed;
  final List<MediaListEntry> current;
  final List<MediaListEntry> dropped;
  final List<MediaListEntry> paused;
  final List<MediaListEntry> planning;
  final List<MediaListEntry> repeating;

  WatchList copyWith({
    List<MediaListEntry>? completed,
    List<MediaListEntry>? current,
    List<MediaListEntry>? dropped,
    List<MediaListEntry>? paused,
    List<MediaListEntry>? planning,
    List<MediaListEntry>? repeating,
  }) {
    return WatchList(
      provider: provider,
      completed: completed ?? this.completed,
      current: current ?? this.current,
      dropped: dropped ?? this.dropped,
      paused: paused ?? this.paused,
      planning: planning ?? this.planning,
      repeating: repeating ?? this.repeating,
    );
  }

  MediaListEntry? getCompletedEntry(Media media) {
    return _getListEntry(completed, media);
  }

  MediaListEntry? getPlanningEntry(Media media) {
    return _getListEntry(planning, media);
  }

  MediaListEntry? getCurrentEntry(Media media) {
    return _getListEntry(current, media) ??
        _getListEntry(repeating, media) ??
        _getListEntry(paused, media) ??
        _getListEntry(dropped, media);
  }

  MediaListEntry? getWatchListEntry(Media media) {
    return _getListEntry(current, media) ??
        _getListEntry(repeating, media) ??
        _getListEntry(paused, media) ??
        _getListEntry(completed, media) ??
        _getListEntry(dropped, media) ??
        _getListEntry(planning, media);
  }

  MediaListEntry? findEntryFromTitle(String? title) {
    if (title == null) return null;

    return _findFromTitle(current, title) ??
        _findFromTitle(repeating, title) ??
        _findFromTitle(paused, title) ??
        _findFromTitle(completed, title) ??
        _findFromTitle(dropped, title) ??
        _findFromTitle(planning, title);
  }

  MediaListEntry? _findFromTitle(
    List<MediaListEntry> entries,
    String title,
  ) {
    return entries.firstWhereOrNull(
      (element) =>
          element.media.title != null &&
          sanitizeName(element.media.title!).toLowerCase() ==
              sanitizeName(title).toLowerCase(),
    );
  }

  MediaListEntry? _getListEntry(
    List<MediaListEntry> entries,
    Media media,
  ) {
    return entries.firstWhereOrNull(
      (element) => switch (provider) {
        WatchListProvider.anilist => media.anilistInfo?.id != null &&
            media.anilistInfo?.id != 0 &&
            element.media.anilistInfo?.id == media.anilistInfo?.id,
        WatchListProvider.mal => media.malInfo?.id != null &&
            element.media.malInfo?.id == media.malInfo?.id,
        WatchListProvider.kitsu => throw UnimplementedError(),
      },
    );
  }

  factory WatchList.fromAnilistWatchList(AnilistWatchList watchList) {
    return WatchList(
      provider: WatchListProvider.anilist,
      completed:
          watchList.completed.map(MediaListEntry.fromAnilistListEntry).toList(),
      current:
          watchList.current.map(MediaListEntry.fromAnilistListEntry).toList(),
      dropped:
          watchList.dropped.map(MediaListEntry.fromAnilistListEntry).toList(),
      paused:
          watchList.paused.map(MediaListEntry.fromAnilistListEntry).toList(),
      planning:
          watchList.planning.map(MediaListEntry.fromAnilistListEntry).toList(),
      repeating:
          watchList.repeating.map(MediaListEntry.fromAnilistListEntry).toList(),
    );
  }

  AnilistWatchList toAnilistWatchList() {
    AnilistWatchListEntry toAnilistWatchListEntry(MediaListEntry entry) =>
        AnilistWatchListEntry(
          media: entry.media.anilistInfo,
          progress: entry.progress,
          updatedAt: entry.updatedAt,
          notes: entry.notes,
          score: entry.score,
          status: entry.status,
        );

    return AnilistWatchList(
      completed: completed.map(toAnilistWatchListEntry).toList(),
      current: current.map(toAnilistWatchListEntry).toList(),
      dropped: dropped.map(toAnilistWatchListEntry).toList(),
      paused: paused.map(toAnilistWatchListEntry).toList(),
      planning: planning.map(toAnilistWatchListEntry).toList(),
      repeating: repeating.map(toAnilistWatchListEntry).toList(),
    );
  }

  bool get isNotEmpty => !isEmpty;
  bool get isEmpty =>
      completed.isEmpty &&
      current.isEmpty &&
      dropped.isEmpty &&
      paused.isEmpty &&
      planning.isEmpty &&
      repeating.isEmpty;

  @override
  List<Object?> get props => [
        provider,
        completed,
        current,
        dropped,
        paused,
        planning,
        repeating,
      ];

  @override
  String toString() {
    return [
      'WatchList(',
      'provider: $provider,',
      '${completed.length} completed entries,',
      '${current.length} current entries,',
      '${dropped.length} completed entries,',
      '${paused.length} completed entries,',
      '${planning.length} planning entries,',
      '${repeating.length} repeating entries',
      ')',
    ].join('');
  }
}
