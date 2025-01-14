import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anikki/data/data.dart';

import '../fixtures/anilist.dart';

void main() {
  late MockGraphQLClient mockGraphQLClient;

  setUp(() {
    mockGraphQLClient = generateMockGraphQLClient();
  });

  group('unit test: Anilist', () {
    group('[getSchedule] method', () {
      test('gets a news schedule if no error occurs', () async {
        final result =
            generateMockQuery<Query$AiringSchedule>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(false);
        when(() => result.parsedData).thenReturn(airingScheduleMock);

        final anilist = Anilist(client: mockGraphQLClient);
        final schedule = await anilist.getSchedule(
            DateTimeRange(start: DateTime.now(), end: DateTime.now()));

        expect(
          schedule.length,
          airingScheduleMock.Page?.airingSchedules?.length,
        );
      });

      test('throws an error if rquery fails ', () async {
        final result =
            generateMockQuery<Query$AiringSchedule>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(true);
        when(() => result.exception).thenReturn(OperationException());

        final anilist = Anilist(client: mockGraphQLClient);

        try {
          await anilist.getSchedule(
              DateTimeRange(start: DateTime.now(), end: DateTime.now()));

          fail('Error was not thrown');
        } catch (e) {
          expect(e, isA<AnilistGetScheduleException>());
        }
      });
    });

    group('[search] method', () {
      test('gets information if no error occurs', () async {
        final result = generateMockQuery<Query$Search>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(false);
        when(() => result.parsedData).thenReturn(
          Query$Search(
            anime: Query$Search$anime(
              results: [
                media.anilistInfo,
              ],
            ),
            characters: Query$Search$characters(
              results: [
                Query$Search$characters$results(id: 1),
              ],
            ),
          ),
        );

        final anilist = Anilist(client: mockGraphQLClient);
        final search = await anilist.search('Hello');

        expect(
          search[AnilistSearchPart.animes]?.length,
          1,
        );
        expect(
          search[AnilistSearchPart.characters]?.length,
          1,
        );
        expect(
          search[AnilistSearchPart.staffs]?.length,
          0,
        );
      });

      test('throws an error if query fails ', () async {
        final result = generateMockQuery<Query$Search>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(true);
        when(() => result.parsedData).thenReturn(null);
        when(() => result.exception).thenReturn(
          OperationException(
            graphqlErrors: [
              const GraphQLError(message: 'Some error'),
            ],
          ),
        );

        final anilist = Anilist(client: mockGraphQLClient);

        try {
          await anilist.search('Hello');

          fail('Error was not thrown');
        } catch (e) {
          expect(e, isA<AnilistSearchException>());
        }
      });
    });

    group('[getMe] method', () {
      test('gets information if no error occurs', () async {
        const name = 'Kylart';
        final result = generateMockQuery<Query$Viewer>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(false);
        when(() => result.parsedData).thenReturn(Query$Viewer(
          Viewer: Query$Viewer$Viewer(name: name, id: 0),
        ));

        final anilist = Anilist(client: mockGraphQLClient);
        final viewer = await anilist.getMe();

        expect(viewer.name, name);
      });

      test('throws an error if query fails ', () async {
        final result = generateMockQuery<Query$Viewer>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(true);
        when(() => result.parsedData).thenReturn(null);
        when(() => result.exception).thenReturn(
          OperationException(
            graphqlErrors: [
              const GraphQLError(message: 'Some error'),
            ],
          ),
        );

        final anilist = Anilist(client: mockGraphQLClient);

        try {
          await anilist.getMe();

          fail('Error was not thrown');
        } catch (e) {
          expect(e, isA<AnilistNotConnectedException>());
        }
      });
    });

    group('[getWatchLists] method', () {
      test('gets lists if no error occurs', () async {
        final resultGetMe = generateMockQuery<Query$Viewer>(mockGraphQLClient);
        when(() => resultGetMe.hasException).thenReturn(false);
        when(() => resultGetMe.parsedData).thenReturn(
          Query$Viewer(
            Viewer: Query$Viewer$Viewer(id: 1, name: 'Kylart'),
          ),
        );

        final result = generateMockQuery<Query$GetLists>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(false);
        when(() => result.parsedData).thenReturn(Query$GetLists(
            MediaListCollection: Query$GetLists$MediaListCollection(lists: [
          Query$GetLists$MediaListCollection$lists(
            entries: [
              Query$GetLists$MediaListCollection$lists$entries(
                status: Enum$MediaListStatus.COMPLETED,
                media: media.anilistInfo,
              ),
            ],
          ),
          Query$GetLists$MediaListCollection$lists(
            entries: [
              Query$GetLists$MediaListCollection$lists$entries(
                status: Enum$MediaListStatus.CURRENT,
                media: media.anilistInfo,
              ),
            ],
          ),
        ])));

        final anilist = Anilist(client: mockGraphQLClient);
        final lists = await anilist.getWatchLists();

        expect(
          lists.completed,
          allOf(
            [
              isNotNull,
              isNotEmpty,
              hasLength(1),
            ],
          ),
        );
        expect(
          lists.current,
          allOf(
            [
              isNotNull,
              isNotEmpty,
              hasLength(1),
            ],
          ),
        );
        expect(
          lists.dropped,
          allOf(
            [isNotNull, isEmpty],
          ),
        );
        expect(
          lists.paused,
          allOf(
            [isNotNull, isEmpty],
          ),
        );
        expect(
          lists.planning,
          allOf(
            [isNotNull, isEmpty],
          ),
        );
        expect(
          lists.repeating,
          allOf(
            [isNotNull, isEmpty],
          ),
        );
      });

      test('throws an error if query fails ', () async {
        final result = generateMockQuery<Query$GetLists>(mockGraphQLClient);
        when(() => result.hasException).thenReturn(true);
        when(() => result.parsedData).thenReturn(null);
        when(() => result.exception).thenReturn(
          OperationException(
            graphqlErrors: [
              const GraphQLError(message: 'Some error'),
            ],
          ),
        );

        final anilist = Anilist(client: mockGraphQLClient);

        try {
          await anilist.getWatchLists();

          fail('Error was not thrown');
        } catch (e) {
          expect(e, isA<AnilistGetListException>());
        }
      });
    });
  });
}
