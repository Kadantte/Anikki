part of 'home_content.dart';

class _HomeSubtitle extends StatelessWidget {
  const _HomeSubtitle({
    required this.media,
  });

  final Media? media;

  @override
  Widget build(BuildContext context) {
    final genres = media?.genres;

    if (genres == null || genres.isEmpty) return const SizedBox();

    return AutoSizeText(
      genres
          .sublist(
            0,
            min(genres.length, 3),
          )
          .join('  •  '),
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}
