part of 'home_content.dart';

class _HomeInformation extends StatelessWidget {
  const _HomeInformation({
    required this.media,
  });

  final Media? media;

  @override
  Widget build(BuildContext context) {
    if (media == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              dense: true,
              title: Text(
                media!.numberOfEpisodes?.toString() ?? 'N/A',
                style: context.textTheme.headlineSmall?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                'episodes',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (media?.season != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              width: 1,
              color: context.colorScheme.onSurface.withOpacity(0.3),
            ),
          if (media?.season != null)
            Expanded(
              child: ListTile(
                dense: true,
                title: AutoSizeText(
                  media!.season?.name.capitalize() ?? '',
                  style:
                      context.textTheme.headlineSmall?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                subtitle: AutoSizeText(
                  media?.seasonYear?.toString() ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
