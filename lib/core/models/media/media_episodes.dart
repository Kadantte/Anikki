part of 'media.dart';

mixin MediaEpisodes on IMedia {
  int? get numberOfEpisodes =>
      anilistInfo?.episodes ??
      anilistInfo?.nextAiringEpisode?.episode ??
      malInfo?.numEpisodes ??
      tmdbInfo?.numberOfEpisodes ??
      tmdbInfo?.tmdbSeasons?.fold<int>(
        0,
        (acc, season) => acc + (season.episodes?.length ?? 0),
      );

  int? get nextAiringEpisode => anilistInfo?.nextAiringEpisode?.episode;
}
