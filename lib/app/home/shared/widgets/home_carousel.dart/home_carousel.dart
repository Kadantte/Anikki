import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/core/core.dart';

part 'home_carousel_navigation.dart';
part 'home_carousel_title.dart';
part 'home_carousel_actions.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({
    super.key,
    required this.medias,
    required this.height,
    required this.width,
  });

  final List<Media> medias;
  final double width;
  final double height;

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final itemAspectRatio = 9 / 14;

  Timer? timer;
  late final ScrollController scrollController;
  final listController = ListController();

  final toNextDuration = const Duration(seconds: 15);
  final itemAnimationDuration = const Duration(milliseconds: 300);

  int currentIndex = 0;
  int get currentMediaIndex => currentIndex % widget.medias.length;
  Media get currentMedia => widget.medias.elementAt(currentMediaIndex);

  @override
  void initState() {
    scrollController = ScrollController();
    setInitialIndex();
    updateCurrentMedia();
    setTimer();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => goToItem(currentIndex),
    );

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void setTimer() {
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
      widget.medias.indexWhere(
        (element) =>
            element.anilistInfo.id ==
            homeBloc.state.currentMedia?.anilistInfo.id,
      ),
      0,
    );
  }

  void updateCurrentMedia() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeCurrentMediaChanged(currentMedia),
    );
  }

  void goToItem(int index, {bool resetTimer = false}) {
    if (resetTimer) {
      timer?.cancel();
      setTimer();
    }

    setState(() {
      currentIndex = max(index, 0);
    });

    listController.animateToItem(
      curve: (estimatedDistance) => Curves.linear,
      duration: (estimatedDistance) => itemAnimationDuration,
      index: currentIndex,
      scrollController: scrollController,
      alignment: 0.0,
    );

    updateCurrentMedia();
  }

  Size get cardSize => Size(widget.width, widget.height);
  double get reducedHeight => cardSize.height / 1.3;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(8.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.surface.withOpacity(0.2),
                context.colorScheme.surface.withOpacity(0.1),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: SuperListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  listController: listController,
                  controller: scrollController,
                  itemCount: 10000000,
                  itemBuilder: (context, index) {
                    final i = index % widget.medias.length;
                    final media = widget.medias.elementAt(i);

                    return InkWell(
                      onTap: () => goToItem(index),
                      child: Padding(
                        padding: index == currentIndex
                            ? const EdgeInsets.only(right: 12.0)
                            : const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: itemAnimationDuration,
                            constraints: BoxConstraints(
                              maxHeight: index == currentIndex
                                  ? cardSize.height
                                  : reducedHeight,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  media.coverImage ?? '',
                                ),
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: itemAspectRatio,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: cardSize.height * itemAspectRatio + 12,
                width:
                    cardSize.width - (cardSize.height * itemAspectRatio + 12),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: cardSize.height - reducedHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 12.0,
                      left: 12.0,
                      top: 4.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: _HomeCarouselTitle(
                                currentMedia: currentMedia,
                              ),
                            ),
                            _HomeCarouselNavigation(
                              text:
                                  '${currentMediaIndex + 1} / ${widget.medias.length}',
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
                        _HomeCarouselActions(
                          media: currentMedia,
                          numberOfItems: widget.medias.length,
                          goToItem: goToItem,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(
                duration: 500.ms,
              )
              .slideX(
                duration: 500.ms,
                end: 0,
                begin: 0.5,
              ),
        ),
      ),
    );
  }
}
