part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class HomeCurrentMediaChanged extends HomeEvent {
  const HomeCurrentMediaChanged(this.entry);

  final MediaListEntry? entry;

  @override
  List<Object?> get props => [
        entry,
      ];
}

final class HomeCurrentBackgroundUrlChanged extends HomeEvent {
  const HomeCurrentBackgroundUrlChanged(this.url);

  final String? url;

  @override
  List<Object?> get props => [
        url,
      ];
}

final class HomeRefreshed extends HomeEvent {
  const HomeRefreshed({
    this.requestedType,
    this.watchList,
  });

  final AnilistWatchList? watchList;
  final HomeMediaType? requestedType;

  @override
  List<Object?> get props => [
        watchList,
        requestedType,
      ];
}
