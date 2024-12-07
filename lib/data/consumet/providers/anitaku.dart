import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

import 'package:anikki/core/core.dart';

import '../models/models.dart';

class Anitaku implements AnimeProvider {
  final baseUrl = 'https://anitaku.io';
  final logo =
      'https://play-lh.googleusercontent.com/MaGEiAEhNHAJXcXKzqTNgxqRmhuKB1rCUgb15UrN_mWUNRnLpO5T1qja64oRasO7mn0';

  final client = Client();

  @override
  Future<List<AnimeResult>> search(
    String query, {
    bool dubbed = false,
  }) async {
    final List<AnimeResult> results = [];

    final res = await client.get(Uri.parse(baseUrl).replace(queryParameters: {
      's': dubbed ? '$query (Dub)' : query,
    }));
    final document = parse(res.body);

    document.querySelectorAll('a.tip').forEach(
      (element) {
        final href = element.attributes['href'];

        results.add(
          AnimeResult(
            id: href?.substring(0, href.length - 1).split('/').last,
            title: element.attributes['title'],
            url: href,
            subOrDub: element.text.toLowerCase().contains('dub')
                ? SubOrDub.dub
                : SubOrDub.sub,
          ),
        );
      },
    );

    return results;
  }

  @override
  Future<List<AnimeEpisode>> fetchAnimeEpisodes(String id) async {
    if (!id.contains(baseUrl)) id = '$baseUrl/series/$id/';

    final res = await client.get(Uri.parse(id));
    final document = parse(res.body);

    return document
        .querySelectorAll('.eplister li>a')
        .map(
          (element) => AnimeEpisode(
            id: element.attributes['href']
                    ?.substring(
                      0,
                      (element.attributes['href']?.length ?? 1) - 1,
                    )
                    .split('/')
                    .last ??
                '',
            url: element.attributes['href'],
            number: int.tryParse(element.querySelector('.epl-num')?.text ?? ''),
            title: element.querySelector('.epl-title')?.text,
          ),
        )
        .toList();
  }

  Future<AnimeSource> _retrieveFromVkPlayer(String videoUriPath) async {
    final url = 'https:$videoUriPath';

    final res = await client.get(Uri.parse(url));
    final document = parse(res.body);

    var scriptContent = document.querySelector('body>script')?.text;

    if (scriptContent == null) throw 'Could not find script';

    final args = scriptContent.split('}(').last;
    final regex = RegExp(r',\d+,\d+,');

    final arg1 = args.split(regex).first;

    final numberArgs = regex.firstMatch(scriptContent);
    final arg2 = int.tryParse(numberArgs?[0]?.split(',').elementAt(1) ?? '');
    final arg3 = int.tryParse(numberArgs?[0]?.split(',').elementAt(2) ?? '');

    var arg4 = args.split(regex).last;
    arg4 = arg4.split('.split').first;

    /// Adapted from the script available in `scriptContent`
    String decipher(String p, int a, int c, List<String> k) {
      while (c-- > 0) {
        if (k.elementAtOrNull(c) != null) {
          p = p.replaceAll(RegExp(r'\b' + c.toRadixString(a) + r'\b'), k[c]);
        }
      }
      return p;
    }

    final result = decipher(arg1, arg2!, arg3!, arg4.split('|'));
    var sources = RegExp(r'sources:.+}]').firstMatch(result)?[0];
    final sourceProperties = [
      'file',
      'label',
    ];

    for (final property in sourceProperties) {
      sources = sources?.replaceAll('$property:', '"$property":');
    }

    final parsedSources =
        json.decode(sources?.substring('sources:'.length) ?? '[]') as List;

    return AnimeSource(
      headers: {},
      sources: [
        for (final source in parsedSources)
          VideoSource(
            url: source['file'],
            quality: source['label'],
          ),
      ],
      download: '',
    );
  }

  @override
  Future<AnimeSource> fetchEpisodeSources(
    AnimeEpisode episode, {
    StreamingServers server = StreamingServers.vidstreaming,
  }) async {
    final res = await client.get(
      Uri.parse(episode.url ?? '$baseUrl/series/${episode.id}/'),
    );
    final document = parse(res.body);

    final iframe = document.querySelector('iframe');
    final rawVideoUrl = iframe?.attributes['src'];

    final isVkPlayer = rawVideoUrl?.startsWith('//vk') == true;

    if (isVkPlayer) {
      return _retrieveFromVkPlayer(rawVideoUrl!);
    }

    return AnimeSource(
      headers: {},
      sources: [],
      download: '',
    );
  }
}
