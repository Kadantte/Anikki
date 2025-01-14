import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/downloader/bloc/downloader_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/home/widgets/landscape/home_title/home_title_carousel/home_title_carousel.dart';
import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/youtube_video_player.dart';
import 'package:anikki/domain/domain.dart';

part 'home_title_actions.dart';
part 'home_title_container.dart';
part 'home_title_subtitle.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    super.key,
    required this.maxSize,
  });

  final Size maxSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final entry = state.currentEntry;

        if (entry == null) return const SizedBox();

        final minWidth = switch (entry.media.images?.backdrops?.length) {
          1 => 246.0,
          2 => 418.0,
          _ => 583.0
        };

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.topLeft,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...previousChildren.map(
                      (e) => Flexible(child: e),
                    )
                  ],
                ),
                if (currentChild != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: currentChild),
                    ],
                  ),
              ],
            );
          },
          child: Column(
            key: ValueKey(
              entry.media.id,
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeTitleContainer(
                maxSize: maxSize,
                minWidth: minWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      entry.media.title ?? 'N/A',
                      style: context.textTheme.headlineLarge,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 16.0,
                      ),
                      child: _HomeTitleSubtitle(
                        entry: entry,
                      ),
                    ),
                    HomeTitleActions(
                      media: entry.media,
                    ),
                  ],
                ),
              ),
              if (entry.media.images?.backdrops?.isNotEmpty == true &&
                  entry.media.images!.backdrops!.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: HomeTitleCarousel(
                    media: entry.media,
                    minWidth: minWidth,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
