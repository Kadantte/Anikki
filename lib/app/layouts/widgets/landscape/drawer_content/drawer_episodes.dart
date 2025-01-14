part of 'drawer_content.dart';

class DrawerEpisodes extends StatelessWidget {
  const DrawerEpisodes({
    super.key,
    this.media,
    this.libraryEntry,
  });

  final Media? media;
  final LibraryEntry? libraryEntry;

  @override
  Widget build(BuildContext context) {
    final nextAiringEpisode = media?.anilistInfo?.nextAiringEpisode?.episode;
    final maxNumberOfEpisodes = <int?>[
      nextAiringEpisode,
      media?.numberOfEpisodes,
      libraryEntry?.entries.length,
      libraryEntry?.epMax,
    ].whereType<int>().sorted((a, b) => b - a).firstOrNull;

    final numberOfEpisodes = nextAiringEpisode ?? maxNumberOfEpisodes;

    if (numberOfEpisodes == null) return const SizedBox();

    /// Listening to `LibraryBloc` so that content refreshes whenever library is updated.
    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryEmpty) {
          Scaffold.of(context).closeEndDrawer();
        }

        if (state is LibraryLoaded &&
            media?.isEmpty == true &&
            libraryEntry?.entries.isEmpty == true) {
          Scaffold.of(context).closeEndDrawer();
        }
      },
      builder: (context, state) {
        final currentLibraryEntry = libraryEntry ??
            (state is LibraryLoaded
                ? state.entries.firstWhereOrNull((entry) =>
                    media?.id != null && entry.media?.id == media?.id)
                : null);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(context),
            vertical: _getHorizontalPadding(context) / 4,
          ),
          child: Paginated(
            initialPage: 0,
            numberOfEntries: numberOfEpisodes,
            pageBuilder: (context, page) {
              return BlocBuilder<LayoutBloc, LayoutState>(
                builder: (context, layoutState) {
                  final portrait = layoutState is LayoutPortrait;

                  return GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 450,
                      childAspectRatio: portrait ? 48 / 9 : 32 / 9,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: portrait ? 8.0 : 0.0,
                    ),
                    itemCount: (numberOfEpisodes - (page * kPaginatedPerPage))
                        .clamp(0, kPaginatedPerPage),
                    itemBuilder: (context, realIndex) {
                      var episodeNumber = numberOfEpisodes -
                          realIndex -
                          (page * kPaginatedPerPage);

                      if (episodeNumber < 1) return const SizedBox();

                      var localFile =
                          currentLibraryEntry?.entries.firstWhereOrNull(
                        (entry) => entry.episode == episodeNumber,
                      );

                      if (media?.isEmpty == true &&
                          currentLibraryEntry != null) {
                        localFile = currentLibraryEntry.entries
                            .elementAtOrNull(realIndex);
                        episodeNumber = localFile?.episode ?? episodeNumber;
                      }

                      return DrawerEpisode(
                        localFile: localFile,
                        libraryEntry: libraryEntry,
                        media: media,
                        episodeNumber: episodeNumber,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
