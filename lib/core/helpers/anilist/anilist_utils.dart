import 'package:collection/collection.dart';

import 'package:anikki/data/data.dart';

class AnilistUtils {
  static Fragment$media getEmptyMedia({
    int id = 0,
    String? title,
  }) =>
      Fragment$media(
        id: id,
        isFavourite: false,
        title:
            title == null ? null : Fragment$media$title(userPreferred: title),
      );

  static int? getEpisodeNumberFromEpisodeTitle(String? title) => int.tryParse(
        title?.split(' ').elementAtOrNull(1) ?? '',
      );
}
