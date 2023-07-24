import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:anikki/core/core.dart';

part 'entry_card_overlay_state.dart';
part 'entry_card_overlay_event.dart';

class EntryCardOverlayBloc
    extends Bloc<EntryCardOverlayEvent, EntryCardOverlayState> {
  EntryCardOverlayBloc() : super(EntryCardOverlayEmpty()) {
    on<EntryCardOverlayEvent>((event, emit) {
      logger.v('EntryCardOverlayEvent event: ${event.runtimeType}');
    });

    on<EntryCardOverlayRequested>(_onRequested);
    on<EntryCardOverlayExpanded>(_onExpanded);
    on<EntryCardOverlayClosed>(_onClose);
  }

  void _onClose(
      EntryCardOverlayClosed event, Emitter<EntryCardOverlayState> emit) {
    if (state is! EntryCardOverlayActive) return;

    emit(EntryCardOverlayEmpty());
  }

  void _onRequested(
      EntryCardOverlayRequested event, Emitter<EntryCardOverlayState> emit) {
    emit(
      EntryCardOverlayActive(
        media: event.media,
        key: event.key,
      ),
    );

    if (event.isExpanded) {
      add(const EntryCardOverlayExpanded());
    }
  }

  void _onExpanded(
      EntryCardOverlayExpanded event, Emitter<EntryCardOverlayState> emit) {
    if (state is! EntryCardOverlayActive) return;

    emit(
      (state as EntryCardOverlayActive).copyWith(
        isExpanded: true,
      ),
    );
  }
}