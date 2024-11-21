import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anikki/domain/domain.dart';

import '../fixtures/anilist.dart';

void main() {
  group('unit test: UserRepository', () {
    late MockAnilist anilist;
    late UserRepository repository;

    group('getCurrentUser method', () {
      group('when API succeeds', () {
        setUp(() {
          anilist = MockAnilist();
          when(() => anilist.getMe()).thenAnswer((_) async => anilistUserMock);

          repository = UserRepository(anilist);
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
          when(() => anilist.getMe()).thenThrow(exception);

          repository = UserRepository(anilist);
        });

        test('throws the same error', () async {
          try {
            await repository.getAnilistCurrentUser();
            fail('Expected exception');
          } on Exception catch (e) {
            expect(e, exception);
          }
        });
      });
    });
  });
}
