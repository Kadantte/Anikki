import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:open_app_file/open_app_file.dart';
import 'package:window_manager/window_manager.dart';

import 'package:anikki/app/torrent/bloc/torrent_bloc.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/video_player/bloc/video_player_bloc.dart';
import 'package:anikki/app/library/bloc/library_bloc.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/app/stream_handler/bloc/stream_handler_bloc.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/core/core.dart';

/// Repository to handle video player needs
class VideoPlayerRepository {
  const VideoPlayerRepository();

  /// Handles fullscreen events
  void handleFullscreen(bool isFullscreen) {
    if (isFullscreen) {
      if (isDesktop()) {
        windowManager.setFullScreen(false);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitDown,
        ]);
      }
    } else {
      if (isDesktop()) {
        windowManager.setFullScreen(true);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }

  static void startOnlinePlay({
    required BuildContext context,
    required List<mk.Media> playlist,
    required Media media,
  }) {
    final videoBloc = BlocProvider.of<VideoPlayerBloc>(context);
    final watchListBloc = BlocProvider.of<WatchListBloc>(context);
    final scaffold = ScaffoldMessenger.of(context);

    videoBloc.add(
      VideoPlayerPlayRequested(
        context: context,
        sources: playlist,
        onVideoComplete: (mkMedia, progress) {
          if (progress < kVideoMinCompletedProgress) return;

          final episode = mkMedia.extras?['episodeNumber'] as int?;

          if (episode == null) return;

          watchListBloc.add(
            WatchListWatched(
              media: media,
              episode: episode,
              scaffold: scaffold,
            ),
          );
        },
      ),
    );
  }

  static void _startFileVideo({
    required BuildContext context,
    LocalFile? file,

    /// TODO: Update this to use a list of [mk.Media]s
    List<String>? playlist,
    Media? media,
    Torrent? torrent,
  }) {
    final videoBloc = BlocProvider.of<VideoPlayerBloc>(context);
    final watchListBloc = BlocProvider.of<WatchListBloc>(context);
    final torrentBloc = BlocProvider.of<TorrentBloc>(context);
    final scaffold = ScaffoldMessenger.of(context);

    videoBloc.add(
      VideoPlayerPlayRequested(
        context: context,
        first: file,
        sources: playlist?.map((e) {
              final file = LocalFile(path: e);

              return mk.Media(
                e,
                extras: {
                  'title': [
                    media?.title ?? file.title ?? e,
                    if (file.episode != null) 'Episode ${file.episode!}'
                  ].join(' - '),
                },
              );
            }).toList() ??
            [],
        onVideoComplete: (mkMedia, progress) async {
          if (torrent != null) {
            torrentBloc.add(
              TorrentRemoveTorrent(torrent, true),
            );
          }

          if (media == null && file?.media == null) return;
          if (progress < kVideoMinCompletedProgress) return;

          watchListBloc.add(
            WatchListWatched(
              entry: media == null
                  ? await LocalFile.createAndSearchMedia(mkMedia.uri)
                  : LocalFile(
                      path: mkMedia.uri,
                      media: media,
                    ),
              scaffold: scaffold,
            ),
          );
        },
      ),
    );
  }

  static Future<void> playFile({
    required BuildContext context,
    LocalFile? file,
    List<String>? playlist,
    Media? media,
    Torrent? torrent,
  }) async {
    assert(
      file != null || (playlist != null && playlist.isNotEmpty),
      'playFile must have file or a non-empty playlist',
    );

    final settings = BlocProvider.of<SettingsBloc>(context)
        .state
        .settings
        .videoPlayerSettings;

    if (!settings.inside) {
      file = file ?? LocalFile(path: playlist!.first);
      BlocProvider.of<WatchListBloc>(context).add(
        WatchListWatched(
          entry: file,
          scaffold: ScaffoldMessenger.of(context),
        ),
      );

      /// We need to escape the brackets because they are not escaped properly
      /// by OpenAppFile.;
      await OpenAppFile.open(
          file.file.path.replaceAll('(', '\\(').replaceAll(')', '\\)'));
    } else {
      final libraryState = BlocProvider.of<LibraryBloc>(context).state;

      _startFileVideo(
        context: context,
        file: file,
        playlist: playlist ??
            (libraryState is LibraryLoaded ? libraryState.playlist : []),
        media: media,
        torrent: torrent,
      );
    }
  }

  static void playAnyway({
    required BuildContext context,
    Fragment$shortMedia? media,
    LibraryEntry? entry,
    int? episode,
  }) {
    final library = BlocProvider.of<LibraryBloc>(context).state;
    final watchList = BlocProvider.of<WatchListBloc>(context).state;

    int? progress;
    LocalFile? file;

    if (episode != null) progress = episode - 1;

    /// If no entry is given, try to find one in the library
    if (entry == null && library is LibraryLoaded) {
      entry = library.entries.firstWhereOrNull(
        (element) => element.media?.anilistInfo.id == media?.id,
      );
    }

    final playlist = library is LibraryLoaded
        ? library.entries.fold<List<String>>(
            [],
            (previousValue, element) => [
              ...previousValue,

              /// Taking `reversed` because the entries of a `LibraryEntry` are sorted descendingly
              /// and we want the next eposide to be the (N + 1)th.
              ...element.entries.reversed.map((e) => e.path),
            ],
          )
        : entry?.entries.reversed.map((e) => e.path);

    final watchListEntry = watchList is WatchListComplete
        ? watchList.current
            .firstWhereOrNull((element) => element.media?.id == media?.id)
        : null;

    if (watchListEntry != null) {
      progress ??= watchListEntry.progress;
    }

    file = entry?.entries
        .firstWhereOrNull((element) => element.episode == (progress ?? 0) + 1);

    if (media?.format == Enum$MediaFormat.MOVIE) {
      file = entry?.entries.first;
    }

    if (file != null) {
      playFile(
        file: file,
        context: context,
        playlist: playlist?.toList(),
        media: Media(anilistInfo: media),
      );
      return;
    }

    /// Could not find any file on disk for this entry.
    /// Requesting stream
    BlocProvider.of<StreamHandlerBloc>(context).add(
      StreamHandlerShowRequested(
        media: media ??
            Fragment$shortMedia(
              id: 0,
              title: Fragment$shortMedia$title(
                userPreferred: entry?.entries.first.title,
              ),
            ),
        minEpisode: progress != null ? progress + 1 : null,
        entry: entry,
      ),
    );
  }
}
