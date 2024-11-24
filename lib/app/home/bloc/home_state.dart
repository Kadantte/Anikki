part of 'home_bloc.dart';

enum HomeMediaType {
  following('currently following animes'),
  toStart('planned animes'),
  trending('trending animes'),
  recommendations('recommended animes');

  final String title;

  const HomeMediaType(this.title);
}

sealed class HomeState extends Equatable {
  const HomeState({
    this.currentMedia,
    this.entries = const [],
    this.currentBackgroundUrl,
    this.type = HomeMediaType.following,
    this.watchListProvider,
  });

  final Media? currentMedia;
  final String? currentBackgroundUrl;
  final List<MediaListEntry> entries;
  final HomeMediaType type;
  final WatchListProvider? watchListProvider;

  MediaListEntry? get currentEntry => entries.firstWhereOrNull(
        (e) => switch (watchListProvider) {
          WatchListProvider.anilist => currentMedia?.anilistInfo?.id != null &&
              e.media.anilistInfo?.id == currentMedia?.anilistInfo?.id,
          WatchListProvider.mal => currentMedia?.malInfo?.id != null &&
              e.media.malInfo?.id == currentMedia?.malInfo?.id,
          WatchListProvider.kitsu => throw UnimplementedError(),
          null => e.media == currentMedia,
        },
      );

  int get currentEntryIndex =>
      currentEntry == null ? 0 : entries.indexOf(currentEntry!);

  @override
  List<Object?> get props => [
        currentMedia,
        currentBackgroundUrl,
        entries,
        type,
      ];

  @override
  String toString() => [
        'HomeState(',
        'type: ${type.title}, ',
        'currentMedia: ${currentMedia?.title}, ',
        'currentBackgroundUrl: $currentBackgroundUrl, ',
        '${entries.length} entries',
        ')'
      ].join('');

  HomeState copyWith({
    Media? currentMedia,
    String? currentBackgroundUrl,
    List<MediaListEntry>? entries,
    HomeMediaType? type,
    WatchListProvider? watchListProvider,
  });
}

final class HomeInitial extends HomeState {
  const HomeInitial({
    super.entries,
    super.currentBackgroundUrl,
    super.currentMedia,
    super.type = HomeMediaType.following,
    super.watchListProvider,
  });

  @override
  HomeInitial copyWith({
    Media? currentMedia,
    String? currentBackgroundUrl,
    List<MediaListEntry>? entries,
    HomeMediaType? type,
    WatchListProvider? watchListProvider,
  }) {
    {
      return HomeInitial(
        currentMedia: currentMedia ?? this.currentMedia,
        currentBackgroundUrl: currentBackgroundUrl ?? this.currentBackgroundUrl,
        entries: entries ?? this.entries,
        type: type ?? this.type,
        watchListProvider: watchListProvider ?? this.watchListProvider,
      );
    }
  }
}

final class HomeLoading extends HomeState {
  const HomeLoading({
    super.entries,
    super.currentBackgroundUrl,
    super.currentMedia,
    super.type,
    super.watchListProvider,
  });

  @override
  HomeLoading copyWith({
    Media? currentMedia,
    String? currentBackgroundUrl,
    List<MediaListEntry>? entries,
    HomeMediaType? type,
    WatchListProvider? watchListProvider,
  }) {
    return HomeLoading(
      currentMedia: currentMedia ?? this.currentMedia,
      currentBackgroundUrl: currentBackgroundUrl ?? this.currentBackgroundUrl,
      entries: entries ?? this.entries,
      type: type ?? this.type,
      watchListProvider: watchListProvider ?? this.watchListProvider,
    );
  }
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    super.entries,
    super.currentBackgroundUrl,
    super.currentMedia,
    super.type,
    super.watchListProvider,
  });

  @override
  HomeLoaded copyWith({
    Media? currentMedia,
    String? currentBackgroundUrl,
    List<MediaListEntry>? entries,
    HomeMediaType? type,
    WatchListProvider? watchListProvider,
  }) {
    return HomeLoaded(
      currentMedia: currentMedia ?? this.currentMedia,
      currentBackgroundUrl: currentBackgroundUrl ?? this.currentBackgroundUrl,
      entries: entries ?? this.entries,
      type: type ?? this.type,
      watchListProvider: watchListProvider ?? this.watchListProvider,
    );
  }
}

final class HomeError extends HomeState {
  const HomeError({
    super.entries,
    super.currentMedia,
    super.type,
    super.currentBackgroundUrl,
    super.watchListProvider,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        entries,
        message,
        type,
        currentBackgroundUrl,
      ];

  @override
  HomeError copyWith({
    Media? currentMedia,
    String? currentBackgroundUrl,
    List<MediaListEntry>? entries,
    HomeMediaType? type,
    WatchListProvider? watchListProvider,
    String? message,
  }) {
    return HomeError(
      currentMedia: currentMedia ?? this.currentMedia,
      currentBackgroundUrl: currentBackgroundUrl ?? this.currentBackgroundUrl,
      entries: entries ?? this.entries,
      type: type ?? this.type,
      watchListProvider: watchListProvider ?? this.watchListProvider,
      message: message ?? this.message,
    );
  }
}
