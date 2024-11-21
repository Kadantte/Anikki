part of 'drawer_content.dart';

class DrawerTitle extends StatelessWidget {
  const DrawerTitle({
    super.key,
    this.media,
    this.libraryEntry,
    this.isInWatchList = false,
  });

  final Media? media;
  final LibraryEntry? libraryEntry;
  final bool isInWatchList;

  @override
  Widget build(BuildContext context) {
    final isConnected = BlocProvider.of<WatchListBloc>(
      context,
      listen: true,
    ).state.connected.values.any((value) => value);

    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
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
                  media?.originalTitle ??
                      dirname(libraryEntry!.entries.first.path),
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
      },
    );
  }
}
