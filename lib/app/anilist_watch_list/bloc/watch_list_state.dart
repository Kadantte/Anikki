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

  final Map<WatchListProvider, WatchList> watchLists;
  final Map<WatchListProvider, bool> connected;
  final WatchListProvider? currentProvider;

  WatchList? get watchList => watchLists[currentProvider];

  List<MediaListEntry> get current => watchList?.current ?? const [];
  List<MediaListEntry> get completed => watchList?.completed ?? const [];
  List<MediaListEntry> get dropped => watchList?.dropped ?? const [];
  List<MediaListEntry> get paused => watchList?.paused ?? const [];
  List<MediaListEntry> get planning => watchList?.planning ?? const [];
  List<MediaListEntry> get repeating => watchList?.repeating ?? const [];

  bool get isEmpty => watchList?.isEmpty == true;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
        connected,
        watchList,
        currentProvider,
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

  WatchListState copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
  });
}

final class WatchListInitial extends WatchListState {
  const WatchListInitial({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });

  @override
  WatchListState copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
  }) {
    return WatchListInitial(
      watchLists: watchLists ?? this.watchLists,
      currentProvider: currentProvider ?? this.currentProvider,
      connected: connected ?? this.connected,
    );
  }
}

final class WatchListLoading extends WatchListState {
  const WatchListLoading({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });

  @override
  WatchListInitial copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
  }) {
    return WatchListInitial(
      watchLists: watchLists ?? this.watchLists,
      currentProvider: currentProvider ?? this.currentProvider,
      connected: connected ?? this.connected,
    );
  }
}

final class WatchListLoaded extends WatchListState {
  const WatchListLoaded({
    required super.watchLists,
    super.currentProvider,
    super.connected,
  });

  @override
  WatchListLoaded copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
  }) {
    return WatchListLoaded(
      watchLists: watchLists ?? this.watchLists,
      currentProvider: currentProvider ?? this.currentProvider,
      connected: connected ?? this.connected,
    );
  }
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
  WatchListNotify copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
    String? title,
    String? description,
    bool? isError,
  }) {
    return WatchListNotify(
      watchLists: watchLists ?? this.watchLists,
      currentProvider: currentProvider ?? this.currentProvider,
      connected: connected ?? this.connected,
      title: title ?? this.title,
      description: description ?? this.description,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
        title,
        currentProvider,
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
  WatchListError copyWith({
    Map<WatchListProvider, WatchList>? watchLists,
    Map<WatchListProvider, bool>? connected,
    WatchListProvider? currentProvider,
    String? message,
  }) {
    return WatchListError(
      watchLists: watchLists ?? this.watchLists,
      currentProvider: currentProvider ?? this.currentProvider,
      connected: connected ?? this.connected,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
        connected,
        currentProvider,
        watchList,
      ];
}
