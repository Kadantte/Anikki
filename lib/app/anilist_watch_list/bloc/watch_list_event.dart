part of 'watch_list_bloc.dart';

abstract class WatchListEvent extends Equatable {
  const WatchListEvent();

  @override
  List<Object?> get props => [];
}

class WatchListRequested extends WatchListEvent {
  const WatchListRequested({required this.provider});

  final WatchListProvider provider;

  @override
  List<Object> get props => [
        provider,
      ];
}

class WatchListAuthUpdated extends WatchListEvent {
  const WatchListAuthUpdated({
    required this.connected,
    required this.provider,
  });

  final bool connected;
  final WatchListProvider provider;

  @override
  List<Object> get props => [
        connected,
        provider,
      ];
}

class WatchListWatched extends WatchListEvent {
  const WatchListWatched({
    required this.media,
    this.episode,
  });

  final Media media;
  final int? episode;

  @override
  List<Object?> get props => [
        media,
        episode,
      ];
}

class WatchListRemoveMedia extends WatchListEvent {
  const WatchListRemoveMedia(
    this.media,
  );

  final Media media;

  @override
  List<Object?> get props => [media];
}

class WatchListToggleFavourite extends WatchListEvent {
  const WatchListToggleFavourite({
    required this.media,
  });

  final Media media;

  @override
  List<Object?> get props => [
        media,
      ];
}
