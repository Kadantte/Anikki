part of 'drawer_content.dart';

class _DrawerContentPortrait extends StatefulWidget {
  const _DrawerContentPortrait({
    required this.media,
    this.libraryEntry,
    required this.isInWatchList,
  });

  final Media media;
  final LibraryEntry? libraryEntry;
  final bool isInWatchList;

  @override
  State<_DrawerContentPortrait> createState() => _DrawerContentPortraitState();
}

class _DrawerContentPortraitState extends State<_DrawerContentPortrait> {
  bool smallTitleCard = false;

  late final ScrollController controller;

  void onScroll() {
    setState(() {
      smallTitleCard = controller.offset > 0;
    });
  }

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(onScroll);

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(onScroll);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconActions = _buildActions(
      media: widget.media,
      libraryEntry: widget.libraryEntry,
    ).where((action) => action.type == DrawerActionType.icon);

    final fullActions = _buildActions(
      media: widget.media,
      libraryEntry: widget.libraryEntry,
    ).where((action) => action.type == DrawerActionType.full);

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.media.title ??
              widget.libraryEntry?.entries.first.title ??
              'N/A',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        actions: [
          if (widget.isInWatchList)
            FavouriteButton(
              media: widget.media,
              filled: false,
            ),
        ],
      ),
      body: Positioned.fill(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                image: smallTitleCard && widget.media.bannerImage != null
                    ? DecorationImage(
                        opacity: 0.3,
                        alignment: Alignment.topCenter,
                        image: CachedNetworkImageProvider(
                          widget.media.bannerImage!,
                        ),
                      )
                    : null,
                border: !smallTitleCard
                    ? null
                    : Border(
                        bottom: BorderSide(
                          width: 1,
                          color: context.colorScheme.surfaceContainerHighest,
                        ),
                      ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    DrawerImage(
                      small: smallTitleCard,
                      media: widget.media,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (final link in _buildLinks(widget.media))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: DrawerLink(
                                    link: link,
                                    media: widget.media,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (final action in iconActions)
                                DrawerActionButton(
                                  action: action,
                                  media: widget.media,
                                  dense: true,
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (final action in fullActions)
                                DrawerActionButton(
                                  action: action,
                                  media: widget.media,
                                  dense: true,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    DrawerGenres(media: widget.media),
                    DrawerDescription(media: widget.media),
                    DrawerEpisodes(
                      media: widget.media,
                      libraryEntry: widget.libraryEntry,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
