import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

part 'provider_auth_event.dart';
part 'provider_auth_state.dart';

class ProviderAuthBloc extends Bloc<ProviderAuthEvent, ProviderAuthState> {
  final UserRepository repository;

  ProviderAuthBloc(this.repository) : super(ProviderAuthState()) {
    on<ProviderAuthLoginRequested>(_login);
    on<ProviderAuthLogoutRequested>(_logout);
  }

  Future<void> _login(
    ProviderAuthLoginRequested event,
    Emitter<ProviderAuthState> emit,
  ) async {
    try {
      emit(
        ProviderAuthState(
          anilistUser: await repository.getAnilistCurrentUser(),
        ),
      );
    } on AnilistNotConnectedException catch (e) {
      emit(
        ProviderAuthError(
          message: e.cause,
          anilistUser: state.anilistUser,
        ),
      );
    } catch (e) {
      emit(
        ProviderAuthError(
          message: e.toString(),
          anilistUser: state.anilistUser,
        ),
      );
    }
  }

  Future<void> _logout(
    ProviderAuthLogoutRequested event,
    Emitter<ProviderAuthState> emit,
  ) async {
    final box = await Hive.openBox(UserRepository.boxName);
    box.delete(UserRepository.tokenKey[event.provider]);

    emit(
      ProviderAuthState(
        anilistUser: event.provider == WatchListProvider.anilist
            ? null
            : state.anilistUser,
      ),
    );
  }
}
