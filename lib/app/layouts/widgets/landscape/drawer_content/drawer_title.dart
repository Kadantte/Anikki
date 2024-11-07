part of 'drawer_content.dart';

class DrawerTitle extends StatelessWidget {
  const DrawerTitle({
    super.key,
    required this.isConnected,
    this.media,
    this.libraryEntry,
    this.isInWatchList = false,
  });

  final Media? media;
  final LibraryEntry? libraryEntry;
  final bool isConnected;
  final bool isInWatchList;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        media?.title ?? libraryEntry?.entries.first.title ?? 'N/A',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.headlineSmall,
      ),
      subtitle: (media?.originalTitle != null &&
                  media?.originalTitle != media?.title) ||
              libraryEntry != null
          ? AutoSizeText(
              media?.originalTitle ?? dirname(libraryEntry!.entries.first.path),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge,
            )
          : null,
      trailing: media != null && isConnected && isInWatchList
          ? FavouriteButton(
              media: media!,
            )
          : null,
    );
  }
}
