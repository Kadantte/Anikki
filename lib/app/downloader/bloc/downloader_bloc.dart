import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  final TorrentSearchRepository repository;

  DownloaderFilter filter = const DownloaderFilter();

  DownloaderBloc(this.repository) : super(const DownloaderClose()) {
    on<DownloaderRequested>(_onDownloaderRequest);
    on<DownloaderClosed>(_onDownloaderClose);
    on<DownloaderFiltered>(_onDownloaderFilter);
  }

  FutureOr<void> _onDownloaderRequest(
      DownloaderRequested event, Emitter<DownloaderState> emit) async {
    final String term = repository.makeTerm(
      media: event.media,
      entry: event.entry,
      episode: event.episode,
      title: event.title,
    );

    try {
      emit(DownloaderShow(term, state is DownloaderSuccess));
      emit(DownloaderLoading(term));

      final result = await repository.searchNyaa(term);
      final filteredTorrents = _filterTorrents(
        result,
        episode: event.episode,
      );

      emit(
        DownloaderSuccess(
          term: term,
          torrents: result,
          filteredTorrents: filteredTorrents,
          filter: filter,
          media: event.media,
          entry: event.entry,
          episode: event.episode,
          isStreaming: event.isStreaming,
        ),
      );
    } on NyaaNoResultException {
      emit(
        DownloaderSuccess(
          term: term,
          torrents: const [],
          filteredTorrents: const [],
          filter: filter,
          media: event.media,
          entry: event.entry,
          episode: event.episode,
          isStreaming: event.isStreaming,
        ),
      );
    } catch (e) {
      emit(DownloaderError(term: term, message: e.toString()));
    }
  }

  FutureOr<void> _onDownloaderClose(
      DownloaderClosed event, Emitter<DownloaderState> emit) async {
    emit(const DownloaderClose());
  }

  FutureOr<void> _onDownloaderFilter(
      DownloaderFiltered event, Emitter<DownloaderState> emit) async {
    if (state is! DownloaderSuccess) return;

    final currentState = state as DownloaderSuccess;

    filter = event.filter;

    emit(
      currentState.copyWith(
        filteredTorrents: _filterTorrents(
          currentState.torrents,
          episode: currentState.episode,
        ),
        filter: filter,
      ),
    );
  }

  List<NyaaTorrent> _filterTorrents(
    List<NyaaTorrent> torrents, {
    int? episode,
  }) {
    if (filter.showAll) return torrents;

    List<NyaaTorrent> result = torrents;

    if (filter.more != null) {
      result = result
          .where(
            (element) =>
                element.name.toLowerCase().contains(filter.more!.toLowerCase()),
          )
          .toList();
    }

    if (filter.qualities.isNotEmpty) {
      final qualityRegex =
          RegExp('(${filter.qualities.map((e) => e.value).join('|')})');

      result = result
          .where((element) => qualityRegex.hasMatch(element.name))
          .toList();
    }

    if (episode != null && filter.smartFilter) {
      result = result
          .where(
            (element) => element.parsed.episode == episode,
          )
          .toList();
    }

    return result;
  }
}
