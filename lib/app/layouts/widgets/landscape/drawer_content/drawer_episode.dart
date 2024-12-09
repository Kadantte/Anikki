part of 'drawer_content.dart';

class DrawerEpisode extends StatelessWidget {
  const DrawerEpisode({
    super.key,
    required this.localFile,
    required this.media,
    required this.episodeNumber,
    this.libraryEntry,
  });

  final LocalFile? localFile;
  final LibraryEntry? libraryEntry;
  final Media? media;
  final int episodeNumber;

  bool get isNextAiringEpisode => episodeNumber == media?.nextAiringEpisode;

  int get seasonNumber =>
      localFile?.season ??
      libraryEntry?.entries.firstOrNull?.season ??
      media?.seasonNumber ??
      1;

  @override
  Widget build(BuildContext context) {
    if (localFile == null && (media == null || media?.anilistInfo?.id == 0)) {
      return const SizedBox();
    }

    final episodeTextStyle = context.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final tmdbSeason = media?.tmdbInfo?.tmdbSeasons?.firstWhereOrNull(
      (season) => season.seasonNumber == seasonNumber,
    );

    final tmdbInfo = tmdbSeason?.episodes?.firstWhereOrNull(
      (episode) => episode.episodeNumber == episodeNumber,
    );

    final anilistInfo = media?.anilistInfo?.streamingEpisodes?.firstWhereOrNull(
      (element) =>
          element?.title?.split(' - ').firstOrNull == 'Episode $episodeNumber',
    );

    final episodeTitle =
        anilistInfo?.title?.split(' - ').sublist(1).join(' - ') ??
            tmdbInfo?.name;

    final thumbnail = anilistInfo?.thumbnail ??
        (tmdbInfo?.stillPath == null
            ? null
            : getTmdbImageUrl(tmdbInfo!.stillPath!));

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      onTap: () {
        if (isNextAiringEpisode) return;

        if (localFile != null) {
          VideoPlayerRepository.playFile(
            context: context,
            file: localFile,
            media: media,
          );

          return;
        }

        VideoPlayerRepository.playAnyway(
          context: context,
          media: media,
          episode: episodeNumber,
        );
      },
      onHover: (_) {},
      child: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          final portrait = state is LayoutPortrait;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Badge(
                  alignment: const Alignment(0.5, -0.9),
                  backgroundColor: Colors.transparent,
                  label: media != null
                      ? DrawerEpisodeCompleted(
                          media: media!,
                          index: episodeNumber,
                        )
                      : null,
                  child: BlocBuilder<LayoutBloc, LayoutState>(
                    builder: (context, state) {
                      return CircleAvatar(
                        radius: 32,
                        backgroundImage: (thumbnail == null
                            ? const AssetImage(
                                'assets/images/cover_placeholder.jpg')
                            : CachedNetworkImageProvider(
                                thumbnail,
                              )) as ImageProvider,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: portrait ? 0 : 24.0,
                    ),
                    child: episodeTitle != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                episodeTitle,
                                maxLines: 2,
                                style: episodeTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Episode $episodeNumber',
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontSize: 9.0,
                                ),
                              )
                            ],
                          )
                        : Text(
                            'Episode $episodeNumber',
                            style: episodeTextStyle,
                          ),
                  ),
                ),
                if (localFile != null)
                  DrawerEpisodeDeleteButton(
                    file: localFile!,
                  )
                else if (media != null && !isNextAiringEpisode)
                  IconButton(
                    onPressed: () =>
                        BlocProvider.of<DownloaderBloc>(context).add(
                      DownloaderRequested(
                        media: media,
                        episode: episodeNumber,
                      ),
                    ),
                    iconSize: 18.0,
                    constraints: const BoxConstraints(),
                    icon: const Icon(HugeIcons.strokeRoundedDownload04),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
