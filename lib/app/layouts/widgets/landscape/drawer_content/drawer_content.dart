import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:simple_icons/simple_icons.dart';

import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/home/widgets/favourite_button.dart';
import 'package:anikki/app/media_details/widgets/media_details_episode/media_details_episode.dart';
import 'package:anikki/app/media_details/widgets/media_details_video_player.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/helpers/notify.dart';
import 'package:anikki/core/widgets/entry/entry_tag.dart';
import 'package:anikki/core/widgets/paginated.dart';
import 'package:anikki/domain/domain.dart';

part 'drawer_action_button.dart';
part 'drawer_banner_image.dart';
part 'drawer_description.dart';
part 'drawer_episodes.dart';
part 'drawer_genres.dart';
part 'drawer_image.dart';
part 'drawer_link.dart';
part 'drawer_title.dart';

const _horizontalPadding = 64.0;

enum DrawerActionType {
  full,
  icon,
}

class DrawerAction {
  DrawerAction({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.type = DrawerActionType.icon,
  });

  final void Function(BuildContext context, Media media) onPressed;
  final String label;
  final IconData icon;
  final DrawerActionType type;
}

final _links = <DrawerAction>[
  DrawerAction(
    onPressed: (context, media) {
      openInBrowser(
        'https://anilist.co/anime/${media.anilistInfo.id}',
      );
    },
    label: 'See on AniList',
    icon: SimpleIcons.anilist,
  ),
  DrawerAction(
    onPressed: (context, media) {
      if (media.anilistInfo.idMal == null) return;

      openInBrowser(
        'https://myanimelist.net/anime/${media.anilistInfo.idMal}',
      );
    },
    label: 'See on MyAnimeList',
    icon: SimpleIcons.myanimelist,
  ),
  DrawerAction(
    onPressed: (context, media) {
      if (media.tmdbInfo?.id == null) return;

      openInBrowser(
        'https://www.themoviedb.org/tv/${media.tmdbInfo?.id}',
      );
    },
    label: 'See on TMDB',
    icon: SimpleIcons.themoviedatabase,
  ),
];

final _actions = <DrawerAction>[
  DrawerAction(
    onPressed: (context, media) {
      final trailerSite = media.anilistInfo.trailer?.site;
      final trailerSiteId = media.anilistInfo.trailer?.id;

      if (trailerSiteId == null || trailerSite == null) {
        return context.notify(
          message: 'No trailer available',
          isError: true,
        );
      }

      showAdaptiveDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => Dialog(
          child: MediaDetailsVideoPlayer(
            url: 'https://www.$trailerSite.com/watch?v=$trailerSiteId',
          ),
        ),
      );
    },
    label: 'Watch trailer',
    icon: HugeIcons.strokeRoundedVideoReplay,
  ),
  DrawerAction(
    onPressed: (context, media) {},
    label: 'Update list entry',
    icon: HugeIcons.strokeRoundedTaskEdit01,
  ),
  DrawerAction(
    type: DrawerActionType.full,
    onPressed: (context, media) => VideoPlayerRepository.playAnyway(
      context: context,
      media: media.anilistInfo,
    ),
    label: 'Watch',
    icon: HugeIcons.strokeRoundedPlay,
  ),
];

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = BlocProvider.of<AnilistAuthBloc>(
      context,
      listen: true,
    ).isConnected;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final media = state.drawerMedia;

        if (media == null) return const SizedBox();

        return Stack(
          children: [
            DrawerBannerImage(media: media),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: _horizontalPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DrawerImage(media: media),
                      Expanded(
                        child: DrawerTitle(
                          media: media,
                          isConnected: isConnected,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Row(
                    children: [
                      for (final (index, link) in _links.indexed) ...[
                        if (index != 0)
                          const SizedBox(
                            width: 24.0,
                          ),
                        DrawerLink(
                          link: link,
                          media: media,
                        ),
                      ],
                      const Spacer(),
                      for (final action in _actions)
                        DrawerActionButton(action: action, media: media)
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DrawerGenres(media: media),
                        DrawerDescription(media: media),
                        DrawerEpisodes(media: media),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}