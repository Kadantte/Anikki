import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchListBloc extends AutoRefreshBloc<WatchListEvent, WatchListState> {
  final UserListRepository repository;

  WatchListBloc(
    this.repository,
  ) : super(
          WatchListInitial(
            currentProvider: WatchListProvider.values.first,
          ),
        ) {
    on<WatchListRequested>(_onRequested);
    on<WatchListWatched>(_onWatched);
    on<WatchListRemoveMedia>(_onRemoveMedia);
    on<WatchListAuthUpdated>(_onAuthUpdated);
    on<WatchListToggleFavourite>(_onToggleFavourite);
    on<WatchListCurrentProviderUpdated>(_onCurrentProviderUpdated);

    setUpAutoRefresh();
  }

  @override
  void autoRefresh() {
    for (final entry in state.connected.entries) {
      final provider = entry.key;
      final connected = entry.value;

      if (!connected) continue;

      add(
        WatchListRequested(provider: provider),
      );
    }
  }

  Media _hydrateMediaWithOtherProviders(Media media) {
    var result = media.copyWith();

    /// Hydrating `media` with other exsting providers using the name to find a match
    for (final provider in WatchListProvider.values) {
      final currentList = state.watchLists[provider];

      if (currentList == null) continue;

      if (media.anilistInfo != null && provider == WatchListProvider.anilist) {
        continue;
      }

      if (media.malInfo != null && provider == WatchListProvider.mal) continue;

      final providerMedia = currentList.findEntryFromTitle(media.title);

      if (providerMedia == null) continue;

      result = media.copyWith(
        anilistInfo: provider == WatchListProvider.anilist
            ? providerMedia.media.anilistInfo
            : null,
        malInfo: provider == WatchListProvider.mal
            ? providerMedia.media.malInfo
            : null,
      );
    }

    return result;
  }

  void _onCurrentProviderUpdated(
    WatchListCurrentProviderUpdated event,
    Emitter<WatchListState> emit,
  ) {
    emit(
      state.copyWith(
        currentProvider: event.provider,
      ),
    );
  }

  void _onAuthUpdated(
    WatchListAuthUpdated event,
    Emitter<WatchListState> emit,
  ) {
    if (event.connected) {
      add(
        WatchListRequested(
          provider: event.provider,
        ),
      );
    } else {
      final watchLists = {...state.watchLists};

      watchLists.removeWhere(
        (provider, watchList) => provider == event.provider,
      );

      emit(
        state.copyWith(
          watchLists: watchLists,
          connected: {
            ...state.connected,
            event.provider: false,
          },
        ),
      );
    }
  }

  Future<void> _onRequested(
    WatchListRequested event,
    Emitter<WatchListState> emit,
  ) async {
    emit(
      WatchListLoading(
        watchLists: state.watchLists,
        currentProvider: state.currentProvider,
        connected: state.connected,
      ),
    );

    try {
      final watchList = await repository.getList(event.provider);

      emit(
        WatchListLoaded(
          watchLists: {
            ...state.watchLists,
            if (watchList != null) event.provider: watchList,
          },
          currentProvider: state.connected.values.every((val) => val == false)
              ? event.provider
              : state.currentProvider,
          connected: {
            ...state.connected,
            event.provider: true,
          },
        ),
      );
    } on AnilistGetListException catch (e) {
      emit(
        WatchListError(
          watchLists: state.watchLists,
          currentProvider: state.currentProvider,
          connected: {
            ...state.connected,
            event.provider: false,
          },
          message: e.error ?? 'Something went wrong...',
        ),
      );
    } catch (e) {
      emit(
        WatchListError(
          watchLists: state.watchLists,
          currentProvider: state.currentProvider,
          connected: {
            ...state.connected,
            event.provider: false,
          },
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onWatched(
    WatchListWatched event,
    Emitter<WatchListState> emit,
  ) async {
    final media = _hydrateMediaWithOtherProviders(event.media);
    final episode = event.episode ?? 1;

    final currentState = state;

    for (final provider in WatchListProvider.values) {
      if (state.connected[provider] != true) continue;

      final watchList = state.watchLists[provider];

      if (watchList == null) continue;

      try {
        final updated = await repository.watchedEntry(
          provider: provider,
          episode: episode,
          media: media,
          watchList: watchList,
        );

        if (!updated) continue;

        emit(
          WatchListNotify(
            watchLists: state.watchLists,
            connected: state.connected,
            currentProvider: state.currentProvider,
            title: '${provider.title} list updated!',
            description: 'Updated ${media.title} with episode $episode.',
          ),
        );

        emit(currentState);

        add(
          WatchListRequested(
            provider: provider,
          ),
        );
      } catch (e) {
        logger.error('Could not update ${provider.title} list');

        emit(
          WatchListNotify(
            watchLists: state.watchLists,
            connected: state.connected,
            currentProvider: state.currentProvider,
            title: 'Could not update ${provider.title} list',
            description: 'Anikki will retry periodically until it succeeds.',
            isError: true,
          ),
        );
        emit(currentState);

        Timer(
          const Duration(minutes: 5),
          () => add(event),
        );
      }
    }
  }

  Future<void> _onRemoveMedia(
    WatchListRemoveMedia event,
    Emitter<WatchListState> emit,
  ) async {
    if (state is! WatchListLoaded) return;

    final currentState = state;
    final media = _hydrateMediaWithOtherProviders(event.media);

    for (final provider in WatchListProvider.values) {
      if (state.connected[provider] != true) continue;

      try {
        await repository.removeEntry(
          media: media,
          provider: provider,
        );

        add(
          WatchListRequested(provider: provider),
        );
      } catch (e) {
        logger.error('Could not remove media from ${provider.title} list', e);

        emit(
          WatchListNotify(
            watchLists: state.watchLists,
            connected: state.connected,
            currentProvider: state.currentProvider,
            title:
                'Could not remove ${event.media.title} from ${provider.title} list',
            description: 'Please retry later',
            isError: true,
          ),
        );

        emit(currentState);
      }
    }
  }

  Future<void> _onToggleFavourite(
    WatchListToggleFavourite event,
    Emitter<WatchListState> emit,
  ) async {
    if (state is! WatchListLoaded) return;

    final currentState = state;

    for (final provider in WatchListProvider.values) {
      if (state.connected[provider] != true) continue;

      final watchList = state.watchLists[provider];

      if (watchList == null) continue;

      try {
        final updatedWatchList = await repository.toggleFavourite(
          watchList: watchList,
          media: event.media,
          provider: provider,
        );

        emit(
          WatchListLoaded(
            connected: state.connected,
            currentProvider: state.currentProvider,
            watchLists: {
              ...state.watchLists,
              provider: updatedWatchList,
            },
          ),
        );
      } catch (e) {
        logger.error('Could not toggle favourite on ${provider.title} list', e);

        emit(
          WatchListNotify(
            watchLists: state.watchLists,
            connected: state.connected,
            currentProvider: state.currentProvider,
            title:
                'Could not toggle favourite for ${event.media.title} from ${provider.title} list',
            description: 'Please retry later',
            isError: true,
          ),
        );

        emit(currentState);
      }
    }
  }
}
