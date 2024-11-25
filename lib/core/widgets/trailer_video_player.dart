import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:media_kit/media_kit.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/video_player/view/video_player_view.dart';
import 'package:anikki/core/widgets/layout_card.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideoPlayer extends StatelessWidget {
  const YoutubeVideoPlayer({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final playerView = FutureBuilder<StreamManifest>(
      future: YoutubeExplode().videos.streams.getManifest(id),
      builder: (context, snapshot) {
        final hasError = snapshot.error != null;

        return switch (snapshot.connectionState) {
          ConnectionState.none => throw UnimplementedError(),
          ConnectionState.waiting || ConnectionState.active => Center(
              child: LoadingWidget(),
            ),
          ConnectionState.done => hasError
              ? Center(
                  child: CustomErrorWidget(
                    title: 'Could not load Youtube video',
                    description:
                        'Please retry later, if the problem persists, the video might have been downed or your app needs to be updated.',
                  ),
                )
              : VideoPlayerView(
                  sources: [
                    Media(
                      snapshot.data!.videoOnly
                          .withHighestBitrate()
                          .url
                          .toString(),
                      extras: {
                        'soundTrackUri': snapshot.data!.audioOnly
                            .withHighestBitrate()
                            .url
                            .toString()
                      },
                    )
                  ],
                  onVideoComplete: (_, __) {},
                  forceSmallControls: true,
                ),
        };
      },
    );

    return Stack(
      children: [
        BlocBuilder<LayoutBloc, LayoutState>(
          builder: (context, state) => switch (state) {
            LayoutPortrait() => playerView,
            LayoutLandscape() => LayoutCard(
                child: playerView,
              ),
          },
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton.filledTonal(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(HugeIcons.strokeRoundedCancel01),
          ),
        ),
      ],
    );
  }
}
