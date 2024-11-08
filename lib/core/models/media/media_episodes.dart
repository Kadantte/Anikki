part of 'media.dart';

mixin MediaEpisodes on IMedia {
  int? get numberOfEpisodes =>
      anilistInfo?.episodes ??
      anilistInfo?.nextAiringEpisode?.episode ??
      tmdbInfo?.numberOfEpisodes ??
      anilistInfo?.streamingEpisodes?.length;

  int? get nextAiringEpisode => anilistInfo?.nextAiringEpisode?.episode;
}
