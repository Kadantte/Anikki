import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/features/anilist_watch_list/presentation/bloc/watch_list_bloc.dart';
import 'package:anikki/features/downloader/presentation/bloc/downloader_bloc.dart';
import 'package:anikki/features/entry_card_overlay/presentation/bloc/entry_card_overlay_bloc.dart';
import 'package:anikki/features/library/domain/models/models.dart';
import 'package:anikki/features/library/presentation/bloc/library_bloc.dart';
import 'package:anikki/features/video_player/presentation/bloc/video_player_bloc.dart';
import 'package:path/path.dart';

void playAnyway({
  required BuildContext context,
  Fragment$shortMedia? media,
  LibraryEntry? entry,
}) {
  final videoBloc = BlocProvider.of<VideoPlayerBloc>(context);
  final library = BlocProvider.of<LibraryBloc>(context).state;
  final watchList = BlocProvider.of<WatchListBloc>(context).state;

  int? progress;
  LocalFile? file;

  /// If no entry is given, try to find one in the library, we never know...
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
    progress = watchListEntry.progress;
  }

  file = entry?.entries
      .firstWhereOrNull((element) => element.episode == (progress ?? 0) + 1);

  if (media?.format == Enum$MediaFormat.MOVIE) {
    file = entry?.entries.first;
  }

  if (file != null) {
    final overlayState = BlocProvider.of<EntryCardOverlayBloc>(context).state;
    final ctx = overlayState is EntryCardOverlayActive
        ? overlayState.rootContext
        : context;

    videoBloc.add(
      VideoPlayerPlayRequested(
        context: context,
        first: file,
        sources: playlist?.toList() ?? [],
        onVideoComplete: (media) {
          final libraryState = BlocProvider.of<LibraryBloc>(ctx).state;

          if (libraryState is! LibraryLoaded) return;

          /// We have to find the `LocalFile` that was just completed
          final entry = libraryState.entries.fold<List<LocalFile>>(
            [],
            (previousValue, element) => [
              ...previousValue,
              ...element.entries.reversed.map((e) => e),
            ],
          ).firstWhere(
              (element) => normalize(element.path) == normalize(media.uri));

          updateEntry(ctx, entry);
        },
      ),
    );

    return;
  }

  /// Could not find any file on disk for this entry.
  /// Opening stream window
  BlocProvider.of<DownloaderBloc>(context).add(
    DownloaderRequested(
      context: context,
      media: media,
      episode: progress != null ? progress + 1 : null,
      entry: entry,
      isStreaming: true,
    ),
  );
}
