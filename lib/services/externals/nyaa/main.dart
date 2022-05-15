import 'package:http/http.dart' as http;

import './types/main.dart';
import './utils.dart' as utils;

class Nyaa {
  String baseUrl = 'nyaa.si';
  var client = http.Client();

  Future<Map<String, dynamic>> _searchPage({String? term, int? page}) async {
    final options = {
      'f': '0',
      'c': '1_0',
      'p': page?.toString() ?? '1',
      's': 'id',
      'o': 'desc',
      'q': term ?? ''
    };

    final uri = Uri.https(baseUrl, '/', options);
    final response = await http.get(uri);

    return utils.extractFromHtml(
        data: response.body, baseUrl: 'https://$baseUrl');
  }

  Future<List<Torrent>> search({String? term}) async {
    final Map<String, dynamic> firstPage = await _searchPage(term: term);

    List<Torrent> results = firstPage['results'];
    int maxPage = firstPage['maxPage'];

    // Current page starts at 2 because we already did one research.
    int currentPage = 2;

    // Should be enough for a few weeks of content.
    const int maxResults = 150;

    while (results.length < maxResults && currentPage < maxPage) {
      final Map<String, dynamic> current =
          await _searchPage(term: term, page: currentPage);

      results.addAll(current['results']);

      ++currentPage;
    }

    return results;
  }
}
