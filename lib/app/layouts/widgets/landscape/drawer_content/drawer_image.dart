part of 'drawer_content.dart';

class DrawerImage extends StatelessWidget {
  const DrawerImage({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    if (media.posterImage == null) return const SizedBox();

    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        child: Hero(
          tag: media.posterImage!,
          child: CachedNetworkImage(
            imageUrl: media.posterImage!,
          ),
        ),
      ),
    );
  }
}
