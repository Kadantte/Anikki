part of 'entry_card.dart';

class _EntryCardCover extends StatelessWidget {
  const _EntryCardCover({
    required this.animation,
    required this.media,
  });

  final Media media;

  final Animation animation;

  /// Color used when loading the image from `url`
  String get color => media.anilistInfo?.coverImage?.color ?? '#0d0d0d';

  String? get url => media.posterImage;

  double get translationValue => animation.value * 150;
  Widget get colorContainer => Container(
        color: hexToColor(color),
        child: const AspectRatio(
          aspectRatio: 11 / 16,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final image = url != null
        ? Hero(
            tag: url!,
            child: CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) => colorContainer,
              placeholder: (context, url) => colorContainer,
            ),
          )
        : Image.asset(
            'assets/images/placeholder.jpg',
            fit: BoxFit.cover,
          );

    return ShaderMask(
      blendMode: BlendMode.lighten,
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment(-0.8, 1),
          colors: [
            Colors.white60,
            Colors.transparent,
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTRB(
            0,
            0,
            rect.width - translationValue,
            rect.height + translationValue,
          ),
        );
      },
      child: Container(
        child: image,
      ),
    );
  }
}
