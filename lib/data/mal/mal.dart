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

  /// Retrieve current user information
  /// Documentaiton: https://myanimelist.net/apiconfig/references/api/v2#operation/users_user_id_get
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

  /// Update an entry on MyAnimeList
  /// Documentaiton: https://myanimelist.net/apiconfig/references/api/v2#operation/anime_anime_id_my_list_status_put
  Future<bool> updateEntry({
    required int mediaId,
    int? episode,
    String? status,
    bool? isRewatching = false,
  }) async {
    try {
      logger.info('Updating MyAnimeList list', {
        'mediaId': mediaId,
        'episode': episode,
        'status': status,
        'isRewatching': isRewatching,
      });

      await client.put(
        Uri.parse('$baseUrl/anime/$mediaId/my_list_status'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          if (status != null) 'status': status,
          if (episode != null) 'num_watched_episodes': episode.toString(),
          if (isRewatching != null) 'is_rewatching': isRewatching.toString(),
        },
      );

      return true;
    } catch (e) {
      logger.error('Could not update MyAnimeList list', e);
      throw MalUpdateListException(
        mediaId: mediaId,
      );
    }
  }

  /// Retrieve Watch list on MyAnimeList for the current user only
  /// Documentaiton: https://myanimelist.net/apiconfig/references/api/v2#operation/users_user_id_animelist_get
  /// Documentation for fields: https://github.com/Chris-Kode/myanimelist-api-v2/blob/master/src/Mal_Api_Authorized/Mal_Api_List_Anime/structures.js
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
                updatedAt: DateTime.parse(
                  entry.listStatus?.updatedAt ?? entry.node?.updatedAt ?? '',
                ).millisecondsSinceEpoch,
              ),
            );
          }

          currentList.sort(
            (a, b) => (b.updatedAt ?? 0).compareTo(a.updatedAt ?? 0),
          );

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
