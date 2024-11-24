import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anikki/domain/domain.dart';

import '../fixtures/anilist.dart';
import '../fixtures/mal.dart';

void main() {
  group('unit test: UserRepository', () {
    late MockAnilist anilist;
    late MockMal mal;
    late UserRepository repository;

    group('getCurrentUser method', () {
      group('when API succeeds', () {
        setUp(() {
          anilist = MockAnilist();
          mal = MockMal();
          when(() => anilist.getMe()).thenAnswer((_) async => anilistUserMock);

          repository = UserRepository(
            anilist: anilist,
            mal: mal,
          );
        });

        test('returns the given user', () async {
          final result = await repository.getAnilistCurrentUser();

          expect(result, anilistUserMock);
        });
      });

      group('when API fails', () {
        final exception = Exception('error');

        setUp(() {
          anilist = MockAnilist();
          mal = MockMal();
          when(() => anilist.getMe()).thenThrow(exception);

          repository = UserRepository(
            anilist: anilist,
            mal: mal,
          );
        });

        test('returns null', () async {
          final user = await repository.getAnilistCurrentUser();
          expect(user, isNull);
        });
      });
    });
  });
}
