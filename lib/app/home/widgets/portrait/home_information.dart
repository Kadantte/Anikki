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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            width: 1,
            color: context.colorScheme.onSurface.withOpacity(0.3),
          ),
          Expanded(
            child: ListTile(
              dense: true,
              title: Text(
                media!.anilistInfo?.season?.name.capitalize() ?? '',
                style: context.textTheme.headlineSmall?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                media!.anilistInfo?.seasonYear.toString() ?? '',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
