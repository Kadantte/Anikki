import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:anikki/app/layouts/shared/helpers/helpers.dart';

part 'layout_event.dart';
part 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  LayoutBloc() : super(LayoutLandscape()) {
    on<LayoutSizeChanged>((event, emit) {
      if (event.constraints.maxWidth >= kWidthBreakpoint) {
        emit(LayoutLandscape());
      } else {
        emit(LayoutPortrait());
      }
    });
  }
}
