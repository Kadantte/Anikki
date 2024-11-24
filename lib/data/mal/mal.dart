import 'dart:convert';

import 'package:anikki/core/core.dart';
import 'package:anikki/core/helpers/mal/mal_client.dart';
import 'package:anikki/data/data.dart';

export 'exceptions/exceptions.dart';
export 'models/models.dart';

class Mal {
  Mal(this.client);

  final MalClient client;

  String get baseUrl => MalClient.baseUrl;

  Future<MalUser> getMe() async {
    final fields = const [
      'id',
      'name',
      'picture',
    ];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/users/@me').replace(
          queryParameters: {
            'fields': fields.join(','),
          },
        ),
      );

      return MalUser.fromJson(response.body);
    } catch (e) {
      throw MalGetUserException(error: e.toString());
    }
  }

  Future<WatchList> getWatchList() async {
    var result = WatchList(
      provider: WatchListProvider.mal,
    );

    final fields = const [
      'id',
      'title',
      'main_picture',
      'alternative_titles',
      'start_date',
      'end_date',
      'synopsis',
      'mean',
      'rank',
      'popularity',
      'num_list_users',
      'num_scoring_users',
      'nsfw',
      'genres',
      // 'created_at',
      'updated_at',
      'media_type',
      'status',
      'my_list_status',
      'list_status',
      'num_episodes',
      'start_season',
      // 'broadcast',
      // 'source',
      // 'average_episode_duration',
      // 'rating',
      // 'studios',
      'score',
      'num_watched_episodes',
      'is_rewatching',
      // 'finish_date',
      // 'priority',
      // 'num_times_rewatched',
      // 'rewatch_value',
      'tags',
    ];

    final statuses = const [
      (malStatus: 'watching', status: Enum$MediaListStatus.CURRENT),
      (malStatus: 'completed', status: Enum$MediaListStatus.COMPLETED),
      (malStatus: 'on_hold', status: Enum$MediaListStatus.PAUSED),
      (malStatus: 'dropped', status: Enum$MediaListStatus.DROPPED),
      (malStatus: 'plan_to_watch', status: Enum$MediaListStatus.PLANNING),
    ];

    for (final status in statuses) {
      int offset = 0;
      int limit = 1000;

      final currentList = <MediaListEntry>[];

      while (true) {
        try {
          final response = await client.get(
            Uri.parse('$baseUrl/users/@me/animelist').replace(
              queryParameters: {
                'fields': fields.join(','),
                'status': status.malStatus,
                'limit': limit.toString(),
                'offset': offset.toString(),
              },
            ),
          );

          final parsedBody = jsonDecode(response.body);
          final paging = parsedBody['paging'];
          final data = (parsedBody['data'] as List)
              .map((e) => MalWatchListResponse.fromMap(e));

          for (final entry in data) {
            currentList.add(
              MediaListEntry(
                media: Media(malInfo: entry.node),
                progress: entry.listStatus?.numEpisodesWatched,
                score: entry.listStatus?.score?.toDouble(),
                status: status.status,
                updatedAt: int.tryParse(
                  entry.listStatus?.updatedAt ?? entry.node?.updatedAt ?? '',
                ),
              ),
            );
          }

          result = result.copyWith(
            current: status.status == Enum$MediaListStatus.CURRENT
                ? currentList
                : result.current,
            completed: status.status == Enum$MediaListStatus.COMPLETED
                ? currentList
                : result.completed,
            dropped: status.status == Enum$MediaListStatus.DROPPED
                ? currentList
                : result.dropped,
            paused: status.status == Enum$MediaListStatus.PAUSED
                ? currentList
                : result.paused,
            planning: status.status == Enum$MediaListStatus.PLANNING
                ? currentList
                : result.planning,
          );

          if (paging == null || paging['next'] == null) break;

          final nextUrl = Uri.parse(paging['next']);

          final currentOffset =
              int.tryParse(nextUrl.queryParameters['offset'] ?? '') ??
                  currentList.length;

          offset = currentOffset;
        } catch (e) {
          logger.error(
            'Error while querying for animelist on MAL for ${status.malStatus} status',
            e,
          );
          break;
        }
      }
    }

    return result;
  }
}
