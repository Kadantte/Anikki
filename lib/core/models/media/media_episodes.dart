part of 'media.dart';

mixin MediaEpisodes on IMedia {
  int? get numberOfEpisodes =>
      anilistInfo?.episodes ??
      anilistInfo?.nextAiringEpisode?.episode ??
      tmdbInfo?.numberOfEpisodes ??
      AnilistUtils.getEpisodeNumberFromEpisodeTItle(
        anilistInfo?.streamingEpisodes?.last?.title,
      );

  int? get nextAiringEpisode => anilistInfo?.nextAiringEpisode?.episode;
}
