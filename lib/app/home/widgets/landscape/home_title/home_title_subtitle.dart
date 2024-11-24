part of 'home_title.dart';

class _HomeTitleSubtitle extends StatelessWidget {
  const _HomeTitleSubtitle({
    required this.entry,
  });

  final MediaListEntry entry;

  Media get media => entry.media;

  TextSpan get separator => const TextSpan(
        text: ' • ',
      );

  String? get season {
    if (media.seasonYear == null || media.season == null) {
      return null;
    }

    return [
      media.season!.name.capitalize(),
      media.seasonYear.toString(),
    ].join(' ');
  }

  int? get episodes =>
      media.numberOfEpisodes ??
      (media.nextAiringEpisode != null ? media.nextAiringEpisode! - 1 : null);

  List<String>? get genres => media.genres;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyLarge,
        children: [
          if (season != null)
            TextSpan(
              text: season,
            ),
          if (episodes != null && episodes != 0) ...[
            separator,
            if (entry.progress != null && entry.progress != 0)
              TextSpan(
                text: 'Episode ${entry.progress}/$episodes',
              )
            else
              TextSpan(
                text: '$episodes episode${episodes == 1 ? '' : 's'}',
              ),
          ] else if (entry.progress != null) ...[
            separator,
            TextSpan(
              text: 'Episode ${entry.progress}',
            )
          ],
          if (genres?.isNotEmpty == true) ...[
            separator,
            TextSpan(
              text: genres!
                  .sublist(
                    0,
                    min(genres!.length, 2),
                  )
                  .join(' • '),
            ),
          ]
        ],
      ),
    );
  }
}
