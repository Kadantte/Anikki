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
    on<ProviderAuthInitialLoginRequested>(_initialLogin);
    on<ProviderAuthLoginRequested>(_login);
    on<ProviderAuthLogoutRequested>(_logout);
  }

  Future<void> _initialLogin(
    ProviderAuthInitialLoginRequested event,
    Emitter<ProviderAuthState> emit,
  ) async {
    emit(
      ProviderAuthState(
        anilistUser: await repository.getAnilistCurrentUser(),
        malUser: await repository.getMalCurrentUser(),
      ),
    );
  }

  Future<void> _login(
    ProviderAuthLoginRequested event,
    Emitter<ProviderAuthState> emit,
  ) async {
    emit(
      state.copyWith(
        anilistUser: event.provider == WatchListProvider.anilist
            ? await repository.getAnilistCurrentUser()
            : state.anilistUser,
        malUser: event.provider == WatchListProvider.mal
            ? await repository.getMalCurrentUser()
            : state.malUser,
      ),
    );
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
        malUser: event.provider == WatchListProvider.mal ? null : state.malUser,
      ),
    );
  }
}
