import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/domain/domain.dart';

import '../fixtures/anilist.dart';
import '../fixtures/mal.dart';
import '../fixtures/tmdb.dart';

void main() {
  group('unit test: UserListRepository', () {
    late MockAnilist anilist;
    late MockMal mal;
    late MockTmdb tmdb;
    late UserListRepository repository;

    group('watchedEntry method', () {
      group('when API succeeds', () {
        setUp(() {
          tmdb = MockTmdb();
          anilist = MockAnilist();
          mal = MockMal();
          when(
            () => anilist.updateEntry(
              episode: 1,
              mediaId: media.id,
              status: null,
            ),
          ).thenAnswer((_) async {});

          when(
            () => anilist.updateEntry(
              episode: 2,
              mediaId: media.id,
              status: null,
            ),
          ).thenAnswer((_) async {});

          repository = UserListRepository(
            anilist: anilist,
            mal: mal,
            tmdb: tmdb,
          );
        });

        test('succeeds when episode is 1', () async {
          await repository.watchedEntry(
            episode: 1,
            media: media,
            provider: WatchListProvider.anilist,
            watchList: const WatchList(provider: WatchListProvider.anilist),
          );
        });

        test('succeeds when episode is not 1', () async {
          await repository.watchedEntry(
            episode: 2,
            media: media,
            provider: WatchListProvider.anilist,
            watchList: const WatchList(provider: WatchListProvider.anilist),
          );
        });
      });

      group('when API fails', () {
        final exception = Exception('error');

        setUp(() {
          tmdb = MockTmdb();
          mal = MockMal();
          anilist = MockAnilist();
          when(
            () => anilist.updateEntry(
              episode: 1,
              mediaId: media.id,
              status: null,
            ),
          ).thenThrow(exception);

          repository = UserListRepository(
            anilist: anilist,
            mal: mal,
            tmdb: tmdb,
          );
        });

        test('fails with the same exception', () async {
          try {
            await repository.watchedEntry(
              episode: 1,
              media: media,
              provider: WatchListProvider.anilist,
              watchList: const WatchList(provider: WatchListProvider.anilist),
            );
            fail('Expected exception');
          } on Exception catch (e) {
            expect(e, exception);
          }
        });
      });
    });

    group('getList method', () {
      group('when API succeeds', () {
        setUp(() {
          tmdb = MockTmdb();
          mal = MockMal();
          anilist = MockAnilist();
          when(
            () => anilist.getWatchLists(),
          ).thenAnswer(
            (_) async => anilistWatchListClassMock,
          );

          repository = UserListRepository(
            anilist: anilist,
            mal: mal,
            tmdb: tmdb,
          );
        });

        test('succeeds', () async {
          final result = await repository.getList(WatchListProvider.anilist);

          expect(result, watchListClassMock);
        });
      });

      group('when API fails', () {
        final exception = Exception('error');

        setUp(() {
          tmdb = MockTmdb();
          mal = MockMal();
          anilist = MockAnilist();
          when(
            () => anilist.getWatchLists(),
          ).thenThrow(exception);

          repository = UserListRepository(
            anilist: anilist,
            mal: mal,
            tmdb: tmdb,
          );
        });

        test('fails with the same exception', () async {
          try {
            await repository.getList(WatchListProvider.anilist);
            fail('Expected exception');
          } on Exception catch (e) {
            expect(e, exception);
          }
        });
      });
    });
  });
}
