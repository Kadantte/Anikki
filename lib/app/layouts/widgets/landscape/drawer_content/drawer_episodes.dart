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
        if (state is LibraryEmpty && media?.anilistInfo?.id == 0) {
          Scaffold.of(context).closeEndDrawer();
        }

        if (state is LibraryLoaded &&
            media?.anilistInfo?.id == 0 &&
            libraryEntry?.entries.isEmpty == true) {
          Scaffold.of(context).closeEndDrawer();
        }
      },
      builder: (context, state) {
        final currentLibraryEntry = libraryEntry ??
            (state is LibraryLoaded
                ? state.entries.firstWhereOrNull((entry) =>
                    entry.media?.anilistInfo?.id == media?.anilistInfo?.id)
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
              return GridView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  childAspectRatio: 32 / 9,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: (numberOfEpisodes - (page * kPaginatedPerPage))
                    .clamp(0, kPaginatedPerPage),
                itemBuilder: (context, realIndex) {
                  var episodeNumber =
                      numberOfEpisodes - realIndex - (page * kPaginatedPerPage);

                  if (episodeNumber < 1) return const SizedBox();

                  var localFile = currentLibraryEntry?.entries.firstWhereOrNull(
                    (entry) => entry.episode == episodeNumber,
                  );

                  if (media == null && currentLibraryEntry != null) {
                    localFile =
                        currentLibraryEntry.entries.elementAtOrNull(realIndex);
                    episodeNumber = localFile?.episode ?? episodeNumber;
                  }

                  return DrawerEpisode(
                    localFile: localFile,
                    media: media,
                    episodeNumber: episodeNumber,
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
