import 'package:anikki/core/core.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>((event, emit) {
      logger.info('HomeEvent: ${event.runtimeType}');
    });

    on<HomeMediaChanged>((event, emit) {
      emit(state.copyWith(media: event.media));
    });
  }
}
