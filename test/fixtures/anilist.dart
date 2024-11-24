import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

class MockAnilist extends Mock implements Anilist {}

class MockQueryManager extends Mock implements QueryManager {}

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockQueryResult<T> extends Mock implements QueryResult<T> {}

class _FakeQueryOptions<T> extends Fake implements QueryOptions<T> {}

class _FakeMutationOptions<T> extends Fake implements MutationOptions<T> {}

MockGraphQLClient generateMockGraphQLClient() {
  final graphQLClient = MockGraphQLClient();
  final queryManager = MockQueryManager();

  when(() => graphQLClient.defaultPolicies).thenReturn(DefaultPolicies());
  when(() => graphQLClient.queryManager).thenReturn(queryManager);

  return graphQLClient;
}

MockQueryResult<T> generateMockQuery<T>(MockGraphQLClient graphQLClient) {
  registerFallbackValue(_FakeQueryOptions<T>());

  final result = MockQueryResult<T>();
  when(() => graphQLClient.query<T>(any())).thenAnswer((_) async => result);

  final queryManager = graphQLClient.queryManager;
  when(() => queryManager.query<T>(any())).thenAnswer((_) async => result);

  return result;
}

MockQueryResult<T> generateMockMutation<T>(MockGraphQLClient graphQLClient) {
  registerFallbackValue(_FakeMutationOptions<T>());

  final result = MockQueryResult<T>();
  when(() => graphQLClient.mutate<T>(any())).thenAnswer((_) async => result);

  final queryManager = graphQLClient.queryManager;
  when(() => queryManager.mutate<T>(any())).thenAnswer((_) async => result);

  return result;
}

const username = 'Kylart';

final anilistUserMock = Query$Viewer$Viewer(name: username, id: 0);

final viewerMock = Query$Viewer(
  Viewer: anilistUserMock,
);

final media = Media(
  anilistInfo: Fragment$media(
    id: 20,
    episodes: 12,
    isFavourite: false,
    title: Fragment$media$title(
      userPreferred: 'Sakura Trick',
    ),
  ),
);

final localFileMock = LocalFile(
  path:
      'test\\resources\\movies\\[SubsPlease] Kaminaki Sekai no Kamisama Katsudou - 03 (1080p) [0328F445].mkv',
  media: media,
  episode: 3,
);

final airingScheduleMock = Query$AiringSchedule(
  Page: Query$AiringSchedule$Page(
    pageInfo: Query$AiringSchedule$Page$pageInfo(
      hasNextPage: false,
      total: 1,
    ),
    airingSchedules: [
      Query$AiringSchedule$Page$airingSchedules(
        id: 1,
        episode: 4,
        airingAt: 0,
        media: AnilistUtils.getEmptyMedia(id: 20),
      ),
      Query$AiringSchedule$Page$airingSchedules(
        id: 2,
        episode: 5,
        airingAt: 0,
        media: AnilistUtils.getEmptyMedia(
          id: 21,
        ),
      ),
    ],
  ),
);

final watchListMock = Query$GetLists(
  MediaListCollection: Query$GetLists$MediaListCollection(
    lists: [
      Query$GetLists$MediaListCollection$lists(
        entries: [
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.CURRENT,
            media: Fragment$media(
              id: 1,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
              nextAiringEpisode: Fragment$media$nextAiringEpisode(
                airingAt: 1,
                episode: 3,
              ),
            ),
            progress: 2,
          ),
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.CURRENT,
            media: Fragment$media(
              id: 2,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
              nextAiringEpisode: Fragment$media$nextAiringEpisode(
                airingAt: 1,
                episode: 6,
              ),
            ),
            progress: 4,
          ),
        ],
      ),
      Query$GetLists$MediaListCollection$lists(
        entries: [
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.COMPLETED,
            media: Fragment$media(
              id: 3,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
            progress: 12,
          ),
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.COMPLETED,
            media: Fragment$media(
              id: 4,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
            progress: 12,
          ),
        ],
      ),
      Query$GetLists$MediaListCollection$lists(
        entries: [
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.DROPPED,
            media: Fragment$media(
              id: 5,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
            progress: 3,
          ),
        ],
      ),
      Query$GetLists$MediaListCollection$lists(
        entries: [
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.PLANNING,
            media: Fragment$media(
              id: 6,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
          ),
        ],
      ),
      Query$GetLists$MediaListCollection$lists(
        entries: [
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.PAUSED,
            media: Fragment$media(
              id: 7,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
            progress: 6,
          ),
          Query$GetLists$MediaListCollection$lists$entries(
            status: Enum$MediaListStatus.PAUSED,
            media: Fragment$media(
              id: 8,
              episodes: 12,
              isAdult: false,
              isFavourite: false,
            ),
            progress: 7,
          ),
        ],
      ),
    ],
  ),
);

final completedEntriesMock = watchListMock.MediaListCollection?.lists
        ?.firstWhere(
          (element) =>
              element?.entries?.first?.status == Enum$MediaListStatus.COMPLETED,
        )
        ?.entries
        ?.whereType<Query$GetLists$MediaListCollection$lists$entries>()
        .toList() ??
    [];
final plannedEntriesMock = watchListMock.MediaListCollection?.lists
        ?.firstWhere(
          (element) =>
              element?.entries?.first?.status == Enum$MediaListStatus.PLANNING,
        )
        ?.entries
        ?.whereType<Query$GetLists$MediaListCollection$lists$entries>()
        .toList() ??
    [];
final currentEntriesMock = watchListMock.MediaListCollection?.lists
        ?.firstWhere(
          (element) =>
              element?.entries?.first?.status == Enum$MediaListStatus.CURRENT,
        )
        ?.entries
        ?.whereType<Query$GetLists$MediaListCollection$lists$entries>()
        .toList() ??
    [];
final droppedEntriesMock = watchListMock.MediaListCollection?.lists
        ?.firstWhere(
          (element) =>
              element?.entries?.first?.status == Enum$MediaListStatus.DROPPED,
        )
        ?.entries
        ?.whereType<Query$GetLists$MediaListCollection$lists$entries>()
        .toList() ??
    [];
final pausedEntriesMock = watchListMock.MediaListCollection?.lists
        ?.firstWhere(
          (element) =>
              element?.entries?.first?.status == Enum$MediaListStatus.PAUSED,
        )
        ?.entries
        ?.whereType<Query$GetLists$MediaListCollection$lists$entries>()
        .toList() ??
    [];

final anilistWatchListClassMock = AnilistWatchList(
  completed: completedEntriesMock,
  current: currentEntriesMock,
  dropped: droppedEntriesMock,
  planning: plannedEntriesMock,
  paused: pausedEntriesMock,
  repeating: const [],
);

final watchListClassMock = WatchList(
  provider: WatchListProvider.anilist,
  completed:
      completedEntriesMock.map(MediaListEntry.fromAnilistListEntry).toList(),
  current: currentEntriesMock.map(MediaListEntry.fromAnilistListEntry).toList(),
  dropped: droppedEntriesMock.map(MediaListEntry.fromAnilistListEntry).toList(),
  planning:
      plannedEntriesMock.map(MediaListEntry.fromAnilistListEntry).toList(),
  paused: pausedEntriesMock.map(MediaListEntry.fromAnilistListEntry).toList(),
  repeating: const [],
);

final watchListUpdateMock = Mutation$UpdateEntry(
  SaveMediaListEntry: Mutation$UpdateEntry$SaveMediaListEntry(id: 1),
);

final characterMock = Query$Search$characters$results(
  id: 0,
  name: Query$Search$characters$results$name(full: 'Hestia'),
);

final staffMock = Query$Search$staff$results(
  id: 0,
  name: Query$Search$staff$results$name(full: 'Minase Inori'),
);

final searchResultMock = {
  AnilistSearchPart.animes: List<Fragment$media>.from([media.anilistInfo]),
  AnilistSearchPart.characters:
      List<Query$Search$characters$results>.from([characterMock]),
  AnilistSearchPart.staffs: List<Query$Search$staff$results>.from([staffMock]),
};
