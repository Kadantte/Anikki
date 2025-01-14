import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'package:anikki/app/watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/home/widgets/landscape/favourite_button.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

part 'home_carousel_actions.dart';
part 'home_carousel_container.dart';
part 'home_carousel_image.dart';
part 'home_carousel_navigation.dart';
part 'home_carousel_title.dart';

const _horizontalPadding = 4.0;

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({
    super.key,
    required this.entries,
    required this.height,
    required this.width,
  });

  final List<MediaListEntry> entries;
  final double width;
  final double height;

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final itemAspectRatio = 9 / 14;
  int? dragDirection;

  Timer? timer;
  late final ScrollController scrollController;
  late final ListController listController;

  final toNextDuration = const Duration(seconds: 15);
  final itemAnimationDuration = const Duration(milliseconds: 300);

  int currentIndex = 0;
  int get currentEntryIndex => currentIndex % widget.entries.length;
  MediaListEntry get currentEntry =>
      widget.entries.elementAt(currentEntryIndex);
  Media get currentMedia => currentEntry.media;

  @override
  void initState() {
    scrollController = ScrollController();
    listController = ListController();
    init();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    listController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.entries.length != widget.entries.length &&
        !const DeepCollectionEquality()
            .equals(oldWidget.entries, widget.entries)) {
      init();
    }
  }

  void init() {
    setInitialIndex();
    updateCurrentMedia();
    setTimer();

    if (currentIndex != 0) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => goToItem(currentIndex),
      );
    }
  }

  void setTimer() {
    timer?.cancel();
    timer = Timer.periodic(
      toNextDuration,
      (_) {
        goToItem(currentIndex + 1);
        updateCurrentMedia();
      },
    );
  }

  void setInitialIndex() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    currentIndex = max(
      widget.entries.indexWhere(
        (element) =>
            element.media.anilistInfo?.id ==
            homeBloc.state.currentMedia?.anilistInfo?.id,
      ),
      0,
    );
  }

  void updateCurrentMedia() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeCurrentMediaChanged(currentEntry),
    );

    updateCurrentBackgroundUrl();
  }

  void updateCurrentBackgroundUrl() {
    String? imageUrl;

    final images = currentMedia.tmdbInfo?.images!.backdrops
        ?.where((image) => image.filePath != null)
        .toList()
      ?..shuffle();

    if (images != null && images.isNotEmpty) {
      final image = images.first;

      if (image.filePath != null) {
        imageUrl = getTmdbImageUrl(image.filePath!);
      }
    }

    imageUrl ??= currentMedia.bannerImage ?? currentMedia.coverImage;

    BlocProvider.of<HomeBloc>(context).add(
      HomeCurrentBackgroundUrlChanged(imageUrl),
    );
  }

  void goToItem(int index, {bool resetTimer = false}) {
    if (!mounted) return;
    if (index < 0) return;

    if (resetTimer) {
      setTimer();
    }

    setState(() {
      currentIndex = index;
      updateCurrentMedia();
    });

    if (!listController.isAttached) return;

    listController.animateToItem(
      curve: (estimatedDistance) => Curves.linear,
      duration: (estimatedDistance) => itemAnimationDuration,
      index: currentIndex,
      scrollController: scrollController,
      alignment: 0.0,
    );
  }

  Size get cardSize => Size(widget.width, widget.height);
  double get titleHeight => 110;
  double get reducedHeight => cardSize.height - titleHeight;

  @override
  Widget build(BuildContext context) {
    return _HomeCarouselContainer(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                dragDirection = details.delta.dx.sign.toInt();
              },
              onHorizontalDragEnd: (details) {
                if (dragDirection == null) return;

                goToItem(
                  currentIndex - dragDirection!,
                  resetTimer: true,
                );
                dragDirection = null;
              },
              child: SuperListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                listController: listController,
                controller: scrollController,
                itemCount: 10000000,
                itemBuilder: (context, index) {
                  final i = index % widget.entries.length;
                  final entry = widget.entries.elementAt(i);

                  return _HomeCarouselImage(
                    goToItem: goToItem,
                    realIndex: index,
                    currentIndex: currentIndex,
                    itemAnimationDuration: itemAnimationDuration,
                    cardSize: cardSize,
                    reducedHeight: reducedHeight,
                    itemAspectRatio: itemAspectRatio,
                    entry: entry,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: cardSize.height * itemAspectRatio + _horizontalPadding,
            width: cardSize.width -
                (cardSize.height * itemAspectRatio + _horizontalPadding),
            height: titleHeight,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: cardSize.height - reducedHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: _horizontalPadding,
                  left: _horizontalPadding,
                  top: 4.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _HomeCarouselTitle(
                              currentMedia: currentEntry.media,
                            ),
                          ),
                          _HomeCarouselNavigation(
                            text:
                                '${currentEntryIndex + 1} / ${widget.entries.length}',
                            onNext: () => goToItem(
                              currentIndex + 1,
                              resetTimer: true,
                            ),
                            onPrevious: () => goToItem(
                              currentIndex - 1,
                              resetTimer: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _HomeCarouselActions(
                      media: currentEntry.media,
                      numberOfItems: widget.entries.length,
                      goToItem: goToItem,
                      onRemoved: () {
                        goToItem(currentIndex);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
