part of 'anilist.dart';

mixin AnilistSchedule on AnilistClient {
  Future<List<Query$AiringSchedule$Page$airingSchedules>> getSchedule(
    DateTimeRange range,
  ) async {
    try {
      int page = 1;
      final List<Query$AiringSchedule$Page$airingSchedules> results = [];

      QueryResult<Query$AiringSchedule> result;

      do {
        result = await client.query$AiringSchedule(
          Options$Query$AiringSchedule(
            variables: Variables$Query$AiringSchedule(
              start: (range.start.millisecondsSinceEpoch / 1000).round(),
              end: (range.end.millisecondsSinceEpoch / 1000).round(),
              page: page,
            ),
          ),
        );

        if (result.hasException) {
          throw AnilistGetScheduleException(error: result.exception.toString());
        }

        results.addAll(
          result.parsedData?.Page?.airingSchedules
                  ?.whereType<Query$AiringSchedule$Page$airingSchedules>() ??
              [],
        );

        page++;
      } while (result.parsedData?.Page?.pageInfo?.hasNextPage == true);

      return results;
    } catch (e) {
      throw AnilistGetScheduleException(error: e.toString());
    }
  }

  Future<List<Query$AiringScheduleWithIds$Page$airingSchedules>>
      getScheduleFromIds(
    DateTimeRange range,
    List<int> ids,
  ) async {
    try {
      int page = 1;
      final List<Query$AiringScheduleWithIds$Page$airingSchedules> results = [];

      QueryResult<Query$AiringScheduleWithIds> result;

      do {
        result = await client.query$AiringScheduleWithIds(
          Options$Query$AiringScheduleWithIds(
            variables: Variables$Query$AiringScheduleWithIds(
              start: (range.start.millisecondsSinceEpoch / 1000).round(),
              end: (range.end.millisecondsSinceEpoch / 1000).round(),
              page: page,
              ids: ids,
            ),
          ),
        );

        if (result.hasException) {
          throw AnilistGetScheduleException(error: result.exception.toString());
        }

        results.addAll(
          result.parsedData?.Page?.airingSchedules?.whereType<
                  Query$AiringScheduleWithIds$Page$airingSchedules>() ??
              [],
        );

        page++;
      } while (result.parsedData?.Page?.pageInfo?.hasNextPage == true);

      return results;
    } catch (e) {
      throw AnilistGetScheduleException(error: e.toString());
    }
  }
}
