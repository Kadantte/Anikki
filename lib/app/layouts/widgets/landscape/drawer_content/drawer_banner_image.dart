part of 'drawer_content.dart';

class DrawerBannerImage extends StatelessWidget {
  const DrawerBannerImage({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    final image = media.bannerImage ?? media.backgroundImage;

    if (image == null) return const SizedBox();

    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        return SizedBox(
          height: state is LayoutLandscape ? 255 : 125,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        );
      },
    );
  }
}
