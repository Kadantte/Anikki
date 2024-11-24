part of 'drawer_content.dart';

class DrawerEpisode extends StatelessWidget {
  const DrawerEpisode({
    super.key,
    required this.localFile,
    required this.media,
    required this.episodeNumber,
  });

  final LocalFile? localFile;
  final Media? media;
  final int episodeNumber;

  bool get isNextAiringEpisode => episodeNumber == media?.nextAiringEpisode;

  @override
  Widget build(BuildContext context) {
    if (localFile == null && (media == null || media?.anilistInfo?.id == 0)) {
      return const SizedBox();
    }

    final episodeTextStyle = context.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final info = media?.anilistInfo?.streamingEpisodes?.firstWhereOrNull(
      (element) =>
          element?.title?.split(' - ').firstOrNull == 'Episode $episodeNumber',
    );

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
      child: Padding(
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
                    radius: state is LayoutPortrait ? 32 : 40,
                    backgroundImage: (info?.thumbnail == null
                        ? const AssetImage(
                            'assets/images/cover_placeholder.jpg')
                        : CachedNetworkImageProvider(
                            info!.thumbnail!,
                          )) as ImageProvider,
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: info?.title != null
                    ? AutoSizeText(
                        info!.title!,
                        maxLines: 3,
                        style: episodeTextStyle,
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
                onPressed: () => BlocProvider.of<DownloaderBloc>(context).add(
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
      ),
    );
  }
}
