part of 'watch_list_bloc.dart';

sealed class WatchListState extends Equatable {
  const WatchListState({
    required this.watchLists,
    this.currentProvider,
    this.connected = const {
      WatchListProvider.anilist: false,
      WatchListProvider.mal: false,
      WatchListProvider.kitsu: false,
    },
  });

  final Map<WatchListProvider, AnilistWatchList> watchLists;
  final Map<WatchListProvider, bool> connected;
  final WatchListProvider? currentProvider;

  AnilistWatchList get watchList =>
      watchLists[currentProvider] ?? const AnilistWatchList();

  List<AnilistWatchListEntry> get current => watchList.current;
  List<AnilistWatchListEntry> get completed => watchList.completed;
  List<AnilistWatchListEntry> get dropped => watchList.dropped;
  List<AnilistWatchListEntry> get paused => watchList.paused;
  List<AnilistWatchListEntry> get planning => watchList.planning;
  List<AnilistWatchListEntry> get repeating => watchList.repeating;

  bool get isEmpty => watchList == const AnilistWatchList();
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
        connected,
        watchList,
      ];

  @override
  String toString() {
    return [
      connected,
      'Current List: ${current.length} entries',
      'Completed List: ${completed.length} entries',
      'Dropped List: ${dropped.length} entries',
      'Paused List: ${paused.length} entries',
      'Planning List: ${planning.length} entries',
      'Repeating List: ${repeating.length} entries',
    ].join(', ');
  }
}

final class WatchListInitial extends WatchListState {
  const WatchListInitial({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });
}

final class WatchListLoading extends WatchListState {
  const WatchListLoading({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });
}

final class WatchListLoaded extends WatchListState {
  const WatchListLoaded({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });
}

final class WatchListNotify extends WatchListState {
  const WatchListNotify({
    required this.title,
    required super.watchLists,
    super.currentProvider,
    super.connected,
    this.description,
    this.isError = false,
  });

  final String title;
  final String? description;
  final bool isError;

  @override
  List<Object?> get props => [
        title,
        description,
        isError,
        connected,
        watchList,
      ];
}

final class WatchListError extends WatchListState {
  const WatchListError({
    required this.message,
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
        connected,
        watchList,
      ];
}
