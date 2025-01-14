import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/domain/domain.dart';

part 'stream_handler_event.dart';
part 'stream_handler_state.dart';

class StreamHandlerBloc extends Bloc<StreamHandlerEvent, StreamHandlerState> {
  final ConsumetRepository repository;

  StreamHandlerBloc(this.repository)
      : super(
          StreamHandlerInitial(
            media: Media(),
          ),
        ) {
    on<StreamHandlerShowRequested>(_onShowRequested);
    on<StreamHandlerCloseRequested>(_onCloseRequested);
    on<StreamHandlerRequested>(_onRequested);
  }

  void _onShowRequested(
    StreamHandlerShowRequested event,
    Emitter<StreamHandlerState> emit,
  ) {
    emit(
      StreamHandlerShowed(
        media: event.media,
        entry: event.entry,
        minEpisode: event.minEpisode,
        type: event.type,
        videoType: state.videoType,
      ),
    );
  }

  void _onCloseRequested(
    StreamHandlerCloseRequested event,
    Emitter<StreamHandlerState> emit,
  ) {
    emit(
      StreamHandlerClosed(
        media: event.media,
        minEpisode: event.minEpisode,
      ),
    );
  }

  Future<void> _onRequested(
    StreamHandlerRequested event,
    Emitter<StreamHandlerState> emit,
  ) async {
    emit(
      StreamHandlerLoading(
        media: event.media,
        minEpisode: event.minEpisode,
        videoType: state.videoType,
      ),
    );

    try {
      final term = event.media.title;

      if (term == null) throw 'No name could be found.';

      final sources = await repository.getEpisodeLinks(
        sanitizeName(term),
        minEpisode: event.minEpisode ?? 0,
        maxLength: 10,
        dubbed: event.videoType == SubOrDub.dub,
      );

      if (sources.isEmpty) throw 'Could not find any hosted video.';

      emit(
        StreamHandlerSuccess(
          media: event.media,
          sources: sources,
          minEpisode: event.minEpisode,
          videoType: event.videoType,
        ),
      );
    } catch (e) {
      emit(
        StreamHandlerError(
          media: event.media,
          error: e.toString(),
          minEpisode: event.minEpisode,
          videoType: event.videoType,
        ),
      );
    }
  }
}
