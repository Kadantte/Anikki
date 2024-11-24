import 'package:bloc_test/bloc_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:anikki/app/provider_auth/bloc/provider_auth_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/user_repository.dart';

import '../../../fixtures/anilist.dart';
import '../../../helpers/init_hive.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  initHive();

  group('unit test: AnilistAuth Bloc', () {
    late ProviderAuthBloc bloc;
    late UserRepository repository;

    blocTest(
      'emits [AnilistAuthSuccess] when [AnilistAuthLoginRequested] is added and succeeds',
      build: () => bloc,
      act: (bloc) => bloc.add(
        ProviderAuthLoginRequested(WatchListProvider.anilist),
      ),
      expect: () => [
        ProviderAuthState(anilistUser: anilistUserMock),
      ],
      setUp: () {
        repository = UserRepositoryMock();

        when(() => repository.getAnilistCurrentUser())
            .thenAnswer((invocation) async => anilistUserMock);

        bloc = ProviderAuthBloc(repository);
      },
    );

    blocTest(
      'emits [AnilistAuthError] when [AnilistAuthLoginRequested] is added but fails',
      build: () => bloc,
      act: (bloc) => bloc.add(
        ProviderAuthLoginRequested(
          WatchListProvider.anilist,
        ),
      ),
      expect: () => [
        ProviderAuthState(
          anilistUser: null,
        ),
      ],
      setUp: () {
        repository = UserRepositoryMock();

        when(() => repository.getAnilistCurrentUser())
            .thenThrow(AnilistNotConnectedException());

        bloc = ProviderAuthBloc(repository);
      },
    );

    blocTest(
      'emits [AnilistAuthLoggedOut] when [AnilistAuthLogoutRequested] is added',
      build: () => bloc,
      act: (bloc) => bloc.add(
        ProviderAuthLogoutRequested(WatchListProvider.anilist),
      ),
      expect: () => [
        isA<ProviderAuthState>(),
      ],
      setUp: () async {
        repository = UserRepositoryMock();
        bloc = ProviderAuthBloc(repository);

        final box = await Hive.openBox(UserRepository.boxName);
        box.put(UserRepository.tokenKey, 'blabla');
      },
      verify: (bloc) async {
        final box = await Hive.openBox(UserRepository.boxName);
        expect(box.get(UserRepository.tokenKey), isNull);
      },
    );
  });
}
