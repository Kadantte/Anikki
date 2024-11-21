import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:anikki/app/watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

import '../../../fixtures/anilist.dart';

class UserListRepositoryMock extends Mock implements UserListRepository {}

void main() {
  group('unit test: WatchList Bloc', () {
    late WatchListBloc bloc;
    late UserListRepositoryMock repository;

    group('on [WatchListRequested],', () {
      blocTest(
        'emits [WatchListLoading, WatchListComplete] when [WatchListRequested] is added',
        build: () => bloc,
        act: (bloc) => bloc.add(
          const WatchListRequested(
            provider: WatchListProvider.anilist,
          ),
        ),
        expect: () => [
          isA<WatchListLoading>(),
          isA<WatchListLoaded>()
              .having(
                (p0) => p0.current.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.CURRENT,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.planning.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.PLANNING,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.completed.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.COMPLETED,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.dropped.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.DROPPED,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.paused.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.PAUSED,
                    )
                    ?.entries
                    ?.length,
              ),
        ],
        setUp: () {
          repository = UserListRepositoryMock();

          when(() => repository.getList(WatchListProvider.anilist))
              .thenAnswer((_) async => watchListClassMock);

          bloc = WatchListBloc(repository);
        },
      );

      blocTest(
        'emits [WatchListLoading, WatchListError] when [WatchListRequested] is added but fails',
        build: () => bloc,
        act: (bloc) => bloc.add(
          const WatchListRequested(
            provider: WatchListProvider.anilist,
          ),
        ),
        expect: () => [
          isA<WatchListLoading>(),
          isA<WatchListError>().having(
            (p0) => p0.message,
            'with an error message',
            isNotNull,
          ),
        ],
        setUp: () {
          repository = UserListRepositoryMock();

          when(() => repository.getList(WatchListProvider.anilist))
              .thenThrow(AnilistGetListException(error: 'error'));

          bloc = WatchListBloc(repository);
        },
      );
    });

    group('on [WatchListWatched]', () {
      WatchListState makeSeedState(bool connected) => WatchListLoaded(
            watchLists: {
              WatchListProvider.anilist:
                  WatchList(provider: WatchListProvider.anilist),
            },
            currentProvider: WatchListProvider.anilist,
            connected: {
              WatchListProvider.anilist: connected,
            },
          );

      blocTest<WatchListBloc, WatchListState>(
        'emits [WatchListLoading, WatchListComplete] when [WatchListWatched] is added',
        build: () => bloc,
        seed: () => makeSeedState(true),
        act: (bloc) => bloc.add(
          WatchListWatched(
            media: anilistMediaMock,
          ),
        ),
        expect: () => [
          isA<WatchListNotify>(),
          isA<WatchListLoaded>(),
        ],
        setUp: () {
          repository = UserListRepositoryMock();

          when(
            () => repository.watchedEntry(
              provider: WatchListProvider.anilist,
              episode: localFileMock.episode!,
              media: localFileMock.media!,
              watchList: WatchList(provider: WatchListProvider.anilist),
            ),
          ).thenAnswer((_) async {});

          when(() => repository.getList(WatchListProvider.anilist))
              .thenAnswer((_) async => watchListClassMock);

          bloc = WatchListBloc(repository);
        },
      );

      blocTest<WatchListBloc, WatchListState>(
        'emits [] when [WatchListWatched] is added but fails',
        build: () => bloc,
        seed: () => makeSeedState(true),
        act: (bloc) => bloc.add(
          WatchListWatched(
            media: anilistMediaMock,
          ),
        ),
        expect: () => [
          isA<WatchListNotify>().having(
            (p0) => p0.isError,
            'with an error notification',
            isTrue,
          ),
          isA<WatchListLoaded>(),
        ],
        setUp: () {
          repository = UserListRepositoryMock();

          when(
            () => repository.watchedEntry(
              provider: WatchListProvider.anilist,
              episode: localFileMock.episode!,
              media: localFileMock.media!,
              watchList: WatchList(provider: WatchListProvider.anilist),
            ),
          ).thenThrow(AnilistUpdateListException(error: 'error'));

          bloc = WatchListBloc(repository);
        },
      );

      blocTest<WatchListBloc, WatchListState>(
        'emits [] when [WatchListWatched] is added but app is not connected',
        build: () => bloc,
        seed: () => makeSeedState(false),
        act: (bloc) => bloc.add(
          WatchListWatched(
            media: anilistMediaMock,
          ),
        ),
        expect: () => [],
        setUp: () {
          repository = UserListRepositoryMock();
          bloc = WatchListBloc(repository);
        },
      );
    });
    group('on [WatchListAuthUpdated]', () {
      blocTest<WatchListBloc, WatchListState>(
        'emits [WatchListInitial] when [WatchListAuthUpdated] is added but app just disconnected',
        build: () => bloc,
        seed: () => const WatchListLoaded(),
        act: (bloc) => bloc.add(
          WatchListAuthUpdated(
            provider: WatchListProvider.anilist,
            connected: false,
          ),
        ),
        expect: () => [
          const WatchListLoaded(
            currentProvider: WatchListProvider.anilist,
          ),
        ],
        setUp: () {
          repository = UserListRepositoryMock();
          bloc = WatchListBloc(repository);
        },
      );

      blocTest<WatchListBloc, WatchListState>(
        'emits [WatchListLoading, WatchListComplete] when [WatchListAuthUpdated] is added but app just connected',
        build: () => bloc,
        seed: () => const WatchListLoaded(),
        act: (bloc) => bloc.add(
          WatchListAuthUpdated(
            provider: WatchListProvider.anilist,
            connected: true,
          ),
        ),
        expect: () => [
          isA<WatchListLoading>(),
          isA<WatchListLoaded>()
              .having(
                (p0) => p0.current.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.CURRENT,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.planning.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.PLANNING,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.completed.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.COMPLETED,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.dropped.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.DROPPED,
                    )
                    ?.entries
                    ?.length,
              )
              .having(
                (p0) => p0.paused.length,
                'with the right amount of current entries',
                watchListMock.MediaListCollection?.lists
                    ?.firstWhereOrNull(
                      (element) =>
                          element?.entries?.first?.status ==
                          Enum$MediaListStatus.PAUSED,
                    )
                    ?.entries
                    ?.length,
              ),
        ],
        setUp: () {
          repository = UserListRepositoryMock();

          when(() => repository.getList(WatchListProvider.anilist))
              .thenAnswer((_) async => watchListClassMock);

          bloc = WatchListBloc(repository);
        },
      );
    });
  });
}
