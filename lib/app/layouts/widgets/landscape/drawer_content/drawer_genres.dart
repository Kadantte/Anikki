part of 'drawer_content.dart';

class DrawerGenres extends StatelessWidget {
  const DrawerGenres({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    if (media.anilistInfo?.genres?.isNotEmpty != true) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(context),
        vertical: 8.0,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          for (final genre in media.anilistInfo!.genres!)
            if (genre != null)
              EntryTag(
                child: Text(
                  genre,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
