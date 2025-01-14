part of 'home_title.dart';

enum HomeActionType {
  icon,
  iconAndText,
}

class HomeAction {
  HomeAction({
    required this.type,
    required this.onPressed,
    required this.icon,
    this.text,
  }) {
    if (type == HomeActionType.iconAndText) {
      assert(text != null);
    }
  }

  final HomeActionType type;
  final void Function(BuildContext context) onPressed;
  final IconData icon;
  final String? text;
}

class HomeTitleActions extends StatelessWidget {
  const HomeTitleActions({
    super.key,
    required this.media,
  });

  final Media media;

  List<HomeAction> get actions => [
        HomeAction(
          type: HomeActionType.iconAndText,
          onPressed: (context) => VideoPlayerRepository.playAnyway(
            context: context,
            media: media,
          ),
          icon: HugeIcons.strokeRoundedPlay,
          text: 'Watch',
        ),
        HomeAction(
          type: HomeActionType.iconAndText,
          onPressed: (context) => BlocProvider.of<DownloaderBloc>(context).add(
            DownloaderRequested(
              media: media,
            ),
          ),
          icon: HugeIcons.strokeRoundedDownload04,
          text: 'Download',
        ),
        if (media.youtubeId != null)
          HomeAction(
            type: HomeActionType.icon,
            onPressed: (context) {
              final trailerContent = YoutubeVideoPlayer(
                id: media.youtubeId!,
              );

              showAdaptiveDialog(
                context: context,
                builder: (context) => Dialog(
                  child: trailerContent,
                ),
              );
            },
            icon: HugeIcons.strokeRoundedVideoReplay,
            text: 'Watch trailer',
          ),
        HomeAction(
          type: HomeActionType.icon,
          onPressed: (context) {},
          icon: HugeIcons.strokeRoundedTaskEdit01,
          text: 'Update list entry',
        ),
        HomeAction(
          type: HomeActionType.icon,
          onPressed: (context) {
            BlocProvider.of<LayoutBloc>(context).add(
              LayoutDrawerMediaChanged(media),
            );

            Scaffold.of(context).openEndDrawer();
          },
          icon: HugeIcons.strokeRoundedMoreHorizontalCircle01,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions) ...[
          switch (action.type) {
            HomeActionType.iconAndText => FilledButton.tonalIcon(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(16.0),
                  ),
                ),
                onPressed: () => action.onPressed(context),
                icon: Icon(
                  action.icon,
                  size: 32,
                ),
                label: Text(
                  action.text!,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            HomeActionType.icon => IconButton.filled(
                tooltip: action.text,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(12.0),
                  ),
                ),
                onPressed: () => action.onPressed(context),
                icon: Icon(
                  action.icon,
                  size: 26,
                ),
              ),
          },
          const SizedBox(
            width: 12.0,
          ),
        ],
      ],
    );
  }
}
