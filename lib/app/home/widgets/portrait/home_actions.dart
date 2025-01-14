part of 'home_content.dart';

class _HomeActions extends StatelessWidget {
  const _HomeActions({
    required this.media,
  });

  final Media? media;

  @override
  Widget build(BuildContext context) {
    if (media == null) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.tonalIcon(
          onPressed: () => VideoPlayerRepository.playAnyway(
            context: context,
            media: media,
          ),
          icon: Icon(HugeIcons.strokeRoundedPlay),
          label: Text('Watch'),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Download',
          onPressed: () {
            BlocProvider.of<DownloaderBloc>(context).add(
              DownloaderRequested(
                media: media,
              ),
            );
          },
          icon: Icon(HugeIcons.strokeRoundedDownload04),
        ),
        IconButton(
          tooltip: 'Show more',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const DrawerContent(),
              ),
            );
          },
          icon: Icon(
            HugeIcons.strokeRoundedMoreHorizontalCircle01,
          ),
        ),
      ],
    );
  }
}
