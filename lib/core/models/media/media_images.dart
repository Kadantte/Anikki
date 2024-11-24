part of 'media.dart';

mixin MediaImages on IMedia {
  TmdbTvImages? get images => tmdbInfo?.images;

  String? get coverImage =>
      anilistInfo?.coverImage?.extraLarge ??
      anilistInfo?.coverImage?.large ??
      malInfo?.mainPicture?.large ??
      anilistInfo?.coverImage?.medium ??
      malInfo?.mainPicture?.medium;
  String? get bannerImage => anilistInfo?.bannerImage;
  String? get backgroundImage {
    final images = tmdbInfo?.images?.backdrops;

    if (images != null && images.isNotEmpty) {
      return getTmdbImageUrl(images.first.filePath!);
    }

    return bannerImage ?? coverImage;
  }

  String? get posterImage {
    final images = tmdbInfo?.images?.posters;

    /// If the media is a season we need to find the appropriate poster image for this season
    if (title != null && tmdbInfo?.seasons?.isNotEmpty == true) {
      final parsedTitle = Anitomy(inputString: title!);
      final seasonNumber = parsedTitle.season ?? parsedTitle.episode;

      final season = tmdbInfo?.seasons
          ?.firstWhereOrNull((season) => season.seasonNumber == seasonNumber);

      if (season != null && season.posterPath != null) {
        return getTmdbImageUrl(season.posterPath!);
      }
    }

    if (images != null && images.isNotEmpty) {
      final jpImage = images.firstWhereOrNull((image) => image.iso6391 == 'ja');
      final enImage = images.firstWhereOrNull((image) => image.iso6391 == 'en');

      if (jpImage?.filePath != null) {
        return getTmdbImageUrl(jpImage!.filePath!);
      }

      if (enImage?.filePath != null) {
        return getTmdbImageUrl(enImage!.filePath!);
      }

      return getTmdbImageUrl(images.first.filePath!);
    }

    return coverImage;
  }
}
