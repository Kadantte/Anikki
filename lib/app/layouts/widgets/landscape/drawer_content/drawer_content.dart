import 'dart:async';
import 'dart:math';

import 'package:anitomy/anitomy.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path/path.dart';
import 'package:simple_icons/simple_icons.dart';

import 'package:anikki/app/downloader/bloc/downloader_bloc.dart';
import 'package:anikki/app/home/widgets/landscape/favourite_button.dart';
import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/library/bloc/library_bloc.dart';
import 'package:anikki/app/watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/empty_widget.dart';
import 'package:anikki/core/widgets/entry/entry_tag.dart';
import 'package:anikki/core/widgets/paginated.dart';
import 'package:anikki/core/widgets/trailer_video_player.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/domain/domain.dart';

part 'drawer_action_button.dart';
part 'drawer_banner_image.dart';
part 'drawer_content_landscape.dart';
part 'drawer_content_portrait.dart';
part 'drawer_description.dart';
part 'drawer_episode.dart';
part 'drawer_episode_completed.dart';
part 'drawer_episode_delete_button.dart';
part 'drawer_episodes.dart';
part 'drawer_genres.dart';
part 'drawer_image.dart';
part 'drawer_link.dart';
part 'drawer_title.dart';

double _getHorizontalPadding(BuildContext context) {
  final bloc = BlocProvider.of<LayoutBloc>(context);

  return bloc.state is LayoutLandscape ? 64.0 : 8.0;
}

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

  final void Function(BuildContext context) onPressed;
  final String label;
  final IconData icon;
  final DrawerActionType type;
}

List<DrawerAction> _buildLinks(Media? media) => [
      if (media?.anilistInfo?.id != null && media?.anilistInfo?.id != 0)
        DrawerAction(
          onPressed: (context) => openInBrowser(
            'https://anilist.co/anime/${media!.anilistInfo?.id}',
          ),
          label: 'See on AniList',
          icon: SimpleIcons.anilist,
        ),
      if (media?.malId != null)
        DrawerAction(
          onPressed: (context) => openInBrowser(
            'https://myanimelist.net/anime/${media!.malId}',
          ),
          label: 'See on MyAnimeList',
          icon: SimpleIcons.myanimelist,
        ),
      if (media?.tmdbInfo?.id != null)
        DrawerAction(
          onPressed: (context) => openInBrowser(
            'https://www.themoviedb.org/tv/${media!.tmdbInfo?.id}',
          ),
          label: 'See on TMDB',
          icon: SimpleIcons.themoviedatabase,
        ),
    ];

List<DrawerAction> _buildActions({
  Media? media,
  LibraryEntry? libraryEntry,
}) =>
    [
      DrawerAction(
        onPressed: (context) {
          final trailerSite = media?.anilistInfo?.trailer?.site;
          final trailerSiteId = media?.anilistInfo?.trailer?.id;

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
              child: TrailerVideoPlayer(
                url: 'https://www.$trailerSite.com/watch?v=$trailerSiteId',
              ),
            ),
          );
        },
        label: 'Watch trailer',
        icon: HugeIcons.strokeRoundedVideoReplay,
      ),
      DrawerAction(
        onPressed: (context) {},
        label: 'Update list entry',
        icon: HugeIcons.strokeRoundedTaskEdit01,
      ),
      DrawerAction(
        onPressed: (context) => BlocProvider.of<DownloaderBloc>(context).add(
          DownloaderRequested(
            media: media,
            entry: libraryEntry,
          ),
        ),
        label: 'Download',
        icon: HugeIcons.strokeRoundedDownload04,
      ),
      DrawerAction(
        type: DrawerActionType.full,
        onPressed: (context) => VideoPlayerRepository.playAnyway(
          context: context,
          media: media,
        ),
        label: 'Watch',
        icon: HugeIcons.strokeRoundedPlay,
      ),
    ];

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListBloc, WatchListState>(
      builder: (context, watchListState) {
        return BlocBuilder<LayoutBloc, LayoutState>(
          builder: (context, state) {
            /// This can happen on touch screen if the user drags the screen on the right
            if (state.drawerMedia == null && state.drawerLibraryEntry == null) {
              return Center(
                child: EmptyWidget(
                  subtitle: 'Select any media to see more details here.',
                ),
              );
            }

            final watchListEntry = WatchListUtils.getWatchListEntry(
              watchListState.watchLists,
              state.drawerMedia!,
            );
            final isInWatchList = watchListEntry != null;

            final libraryEntry = state.drawerLibraryEntry;
            final drawerMedia = state.drawerMedia?.copyWith(
              anilistInfo: watchListEntry?.media.anilistInfo,
            );

            if ((drawerMedia == null || drawerMedia.anilistInfo?.id == 0) &&
                libraryEntry != null) {
              final content = ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getHorizontalPadding(context),
                      vertical: _getHorizontalPadding(context) / 2,
                    ),
                    child: DrawerTitle(
                      media: drawerMedia,
                      libraryEntry: libraryEntry,
                      isInWatchList: isInWatchList,
                    ),
                  ),
                  DrawerEpisodes(
                    libraryEntry: libraryEntry,
                  ),
                ],
              );

              return BlocBuilder<LayoutBloc, LayoutState>(
                builder: (context, state) {
                  return state is LayoutPortrait
                      ? Scaffold(
                          body: content,
                        )
                      : content;
                },
              );
            }

            return FutureBuilder<Media>(
                future: tmdb.hydrateMediaWithTmdb(drawerMedia!),
                builder: (context, snapshot) {
                  final media = snapshot.data ?? drawerMedia;

                  return BlocBuilder<LayoutBloc, LayoutState>(
                    builder: (context, state) {
                      return state is LayoutPortrait
                          ? _DrawerContentPortrait(
                              media: media,
                              libraryEntry: libraryEntry,
                              isInWatchList: isInWatchList,
                            )
                          : _DrawerContentLandscape(
                              media: media,
                              libraryEntry: libraryEntry,
                              isInWatchList: isInWatchList,
                            );
                    },
                  );
                });
          },
        );
      },
    );
  }
}
