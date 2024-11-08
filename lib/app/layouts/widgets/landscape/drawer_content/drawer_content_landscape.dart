part of 'drawer_content.dart';

class _DrawerContentLandscape extends StatelessWidget {
  const _DrawerContentLandscape({
    required this.media,
    required this.libraryEntry,
    required this.isInWatchList,
  });

  final Media media;
  final LibraryEntry? libraryEntry;
  final bool isInWatchList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DrawerBannerImage(media: media),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _getHorizontalPadding(context) + 12.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getHorizontalPadding(context),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DrawerImage(media: media),
                  Expanded(
                    child: DrawerTitle(
                      media: media,
                      libraryEntry: libraryEntry,
                      isInWatchList: isInWatchList,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: _getHorizontalPadding(context),
                right: _getHorizontalPadding(context),
                bottom: 4.0,
              ),
              child: Row(
                children: [
                  for (final (index, link) in _buildLinks(media).indexed) ...[
                    if (index != 0)
                      const SizedBox(
                        width: 24.0,
                      ),
                    DrawerLink(
                      link: link,
                      media: media,
                    ),
                  ],
                  const Spacer(),
                  for (final action in _buildActions(
                    media: media,
                    libraryEntry: libraryEntry,
                  ))
                    DrawerActionButton(
                      action: action,
                      media: media,
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerGenres(media: media),
                    DrawerDescription(media: media),
                    DrawerEpisodes(
                      media: media,
                      libraryEntry: libraryEntry,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
