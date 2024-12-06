import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart';

import 'package:anikki/core/core.dart';

import '../models/models.dart';

/// Adapted from `https://github.com/consumet/consumet.ts/blob/master/src/providers/anime/anify.ts`
class Anify implements AnimeProvider {
  final baseUrl = 'https://anify.eltik.cc';

  final client = Client();

  final provider = 'animepahe';

  @override
  Future<List<AnimeResult>> search(
    String query, {
    bool dubbed = false,
  }) async {
    final results = <AnimeResult>[];

    final res = await client.get(
      Uri.parse(baseUrl).replace(
        pathSegments: [
          'search',
          'anime',
          query,
        ],
      ),
    );

    final entries = json.decode(res.body)['results'] as List? ?? [];

    for (final entry in entries) {
      results.add(
        AnimeResult(
          id: entry['id'],
          title: entry['title']?['romaji'] ?? entry['title']?['english'],
          url: '',
          subOrDub: SubOrDub.sub,
        ),
      );
    }

    return results;
  }

  @override
  Future<List<AnimeEpisode>> fetchAnimeEpisodes(String id) async {
    final results = <AnimeEpisode>[];

    final res = await client.get(
      Uri.parse(baseUrl).replace(
        pathSegments: [
          'info',
          id,
        ],
      ),
    );

    final parsedResponse = json.decode(res.body);
    final mediaId = parsedResponse['id'] as String?;
    var entries = parsedResponse['episodes']['data'] as List;

    entries = entries.firstWhereOrNull(
      (entry) => entry['providerId'] == provider,
    )?['episodes'];

    for (final entry in entries) {
      results.add(
        AnimeEpisode(
          id: entry['id'],
          number: entry['number'],
          title: entry['title'],
          mediaId: mediaId,
          url: '',
        ),
      );
    }

    return results;
  }

  @override
  Future<AnimeSource> fetchEpisodeSources(
    AnimeEpisode episode, {
    StreamingServers server = StreamingServers.vidstreaming,
  }) async {
    final res = await client.get(
      Uri.parse(baseUrl).replace(
        pathSegments: ['sources'],
        queryParameters: {
          'providerId': provider,
          'watchId': episode.id,
          'episodeNumber': episode.number?.toString(),
          'id': episode.mediaId,
          'subType': 'sub',
        },
      ),
    );

    final parsedResponse = json.decode(res.body);
    final sources = parsedResponse['sources'] as List? ?? [];

    return AnimeSource(
      headers: Map.from(parsedResponse['headers']),
      download: '',
      sources: [
        for (final source in sources)
          VideoSource(
            url: source['url'],
            quality: source['quality'],
          ),
      ],
    );
  }
}
