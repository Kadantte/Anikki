part of 'home_content.dart';

class _HomeTitleCard extends StatelessWidget {
  const _HomeTitleCard({required this.media});

  final Media? media;

  @override
  Widget build(BuildContext context) {
    if (media == null) return const SizedBox();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 390),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Row(
              children: [
                ...previousChildren.map(
                  (e) => Flexible(child: e),
                )
              ],
            ),
            if (currentChild != null)
              Row(
                children: [
                  Expanded(child: currentChild),
                ],
              ),
          ],
        );
      },
      child: Container(
        key: ValueKey(media),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          border: Border.all(
            color: context.colorScheme.surfaceContainerHighest.withOpacity(0.7),
            width: 4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: _HomeTitle(
                media: media,
              ),
              subtitle: _HomeSubtitle(
                media: media,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: _HomeInformation(
                media: media,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              child: _HomeActions(
                media: media,
              ),
            )
          ],
        ),
      ),
    );
  }
}
