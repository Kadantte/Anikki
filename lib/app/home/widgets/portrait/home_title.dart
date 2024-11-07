part of 'home_content.dart';

class _HomeTitle extends StatelessWidget {
  const _HomeTitle({
    required this.media,
  });

  final Media? media;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      media?.title ?? 'N/A',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: context.textTheme.headlineSmall,
    );
  }
}
