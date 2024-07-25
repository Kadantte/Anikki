import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:anikki/app/home/shared/widgets/home_scroll_view/home_scroll_view_loader_tile.dart';
import 'package:anikki/app/home/widgets/home_entry.dart';
import 'package:anikki/core/core.dart';

part 'home_scroll_view_loader.dart';

class HomeScrollView extends StatefulWidget {
  HomeScrollView({
    super.key,
    this.medias,
    this.loading = false,
    this.customTagsBuilder,
  }) {
    if (!loading) assert(medias != null);
  }

  final List<Media>? medias;
  final bool loading;
  final List<String> Function(Media media)? customTagsBuilder;

  static double getHeight(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return max(screenSize.height / 2.5, 400);
  }

  @override
  State<HomeScrollView> createState() => _HomeScrollViewState();
}

class _HomeScrollViewState extends State<HomeScrollView> {
  int? currentlyHoveredId;

  late final ScrollController scrollController;

  final scrollAnimationDuration = const Duration(milliseconds: 500);
  final scrollAnimationCurve = Curves.decelerate;
  final scrollAnimationOffset = 500;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> setCurrentlyExpandedEntry(int? id) async {
    setState(() {
      currentlyHoveredId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeScrollView.getHeight(context),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                scrollController.animateTo(
                  max(scrollController.offset - scrollAnimationOffset, 0),
                  duration: scrollAnimationDuration,
                  curve: scrollAnimationCurve,
                );
              },
              icon: const Icon(Ionicons.chevron_back),
            ),
          ),
          Expanded(
            child: widget.loading
                ? HomeScrollViewLoader(
                    scrollController: scrollController,
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final (index, media) in widget.medias!.indexed)
                          Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : 32.0,
                            ),
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => setCurrentlyExpandedEntry(
                                media.anilistInfo.id == currentlyHoveredId
                                    ? null
                                    : media.anilistInfo.id,
                              ),
                              child: MouseRegion(
                                onEnter: (event) => setCurrentlyExpandedEntry(
                                  media.anilistInfo.id,
                                ),
                                onExit: (event) =>
                                    setCurrentlyExpandedEntry(null),
                                child: HomeEntry(
                                  media: media,
                                  expanded: currentlyHoveredId ==
                                      media.anilistInfo.id,
                                  customTags: widget.customTagsBuilder != null
                                      ? widget.customTagsBuilder!(media)
                                      : const [],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                final height = HomeScrollView.getHeight(context);
                final expandedWidth = height * HomeEntry.expandedAspectRatio;
                final nonExpandedWidth =
                    height * HomeEntry.nonExpandedAspectRatio;

                scrollController.animateTo(
                  min(
                    scrollController.offset + scrollAnimationOffset,
                    scrollController.position.maxScrollExtent +
                        expandedWidth -
                        nonExpandedWidth,
                  ),
                  duration: scrollAnimationDuration,
                  curve: scrollAnimationCurve,
                );
              },
              icon: const Icon(Ionicons.chevron_forward),
            ),
          ),
        ],
      ),
    );
  }
}
