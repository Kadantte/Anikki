part of 'home_content.dart';

class _HomeCarousel extends StatefulWidget {
  const _HomeCarousel({required this.entries});

  final List<MediaListEntry> entries;

  @override
  State<_HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<_HomeCarousel> {
  final ExpandableCarouselController _controller =
      ExpandableCarouselController();
  late final ScrollController scrollController;
  late final ListController listController;

  @override
  void initState() {
    scrollController = ScrollController();
    listController = ListController();

    BlocProvider.of<LayoutBloc>(context).add(
      LayoutDrawerMediaChanged(widget.entries.first.media),
    );

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ExpandableCarousel.builder(
          options: ExpandableCarouselOptions(
            controller: _controller,
            aspectRatio: 9 / 16,
            viewportFraction: 0.75,
            autoPlayInterval: const Duration(seconds: 15),
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            autoPlay: true,
            showIndicator: false,
            floatingIndicator: false,
            restorationId: 'expandable_carousel',
            initialPage: state.currentEntry == null
                ? 0
                : state.entries.indexOf(state.currentEntry!),
            onPageChanged: (index, reason) {
              final entry =
                  widget.entries.elementAt(index % widget.entries.length);

              BlocProvider.of<HomeBloc>(context).add(
                HomeCurrentMediaChanged(entry),
              );

              BlocProvider.of<LayoutBloc>(context).add(
                LayoutDrawerMediaChanged(entry.media),
              );
            },
          ),
          itemCount: widget.entries.length,
          itemBuilder: (context, index, realIdx) {
            final entry = widget.entries.elementAt(index);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                height: screenSize.height / 2,
                child: entry.media.posterImage != null
                    ? Hero(
                        tag: entry.media.posterImage!,
                        child: CachedNetworkImage(
                          imageUrl: entry.media.posterImage!,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      )
                    : const SizedBox(),
              ),
            );
          },
        );
      },
    );
  }
}
