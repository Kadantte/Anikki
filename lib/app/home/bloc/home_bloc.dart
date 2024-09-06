import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserListRepository userListRepository;
  final FeedRepository feedRepository;

  HomeBloc({
    required this.userListRepository,
    required this.feedRepository,
  }) : super(const HomeState()) {
    on<HomeCurrentMediaChanged>((event, emit) {
      emit(
        state.copyWith(
          currentMedia: event.entry?.media,
        ),
      );
    });

    on<HomeCurrentBackgroundUrlChanged>((event, emit) {
      emit(
        state.copyWith(
          currentBackgroundUrl: event.url,
        ),
      );
    });

    on<HomeRefreshed>(_onRefresh);
  }

  Future<void> _onRefresh(HomeRefreshed event, Emitter<HomeState> emit) async {
    List<MediaListEntry>? entries;

    try {
      emit(
        HomeLoading(
          entries: state.entries,
          currentMedia: state.currentMedia,
          currentBackgroundUrl: state.currentBackgroundUrl,
        ),
      );

      entries = event.connected
          ? await userListRepository.getContinueList(event.watchList)
          : (await feedRepository.getTrending())
              .map(
                (media) => MediaListEntry(media: media, progress: null),
              )
              .toList();

      emit(
        HomeLoaded(
          entries: entries,
          currentMedia: state.currentMedia,
          currentBackgroundUrl: state.currentBackgroundUrl,
        ),
      );
    } on AnilistGetListException catch (e) {
      emit(
        HomeError(
          entries: state.entries,
          currentMedia: state.currentMedia,
          currentBackgroundUrl: state.currentBackgroundUrl,
          message: e.error ?? e.cause,
        ),
      );
    } on AnilistGetTrendingException catch (e) {
      emit(
        HomeError(
          entries: entries ?? state.entries,
          currentBackgroundUrl: state.currentBackgroundUrl,
          currentMedia: state.currentMedia,
          message: e.error ?? e.cause,
        ),
      );
    } catch (e) {
      emit(
        HomeError(
          entries: entries ?? state.entries,
          currentBackgroundUrl: state.currentBackgroundUrl,
          currentMedia: state.currentMedia,
          message: e.toString(),
        ),
      );
    }
  }
}
