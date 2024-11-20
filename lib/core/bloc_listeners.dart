import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/downloader/bloc/downloader_bloc.dart';
import 'package:anikki/app/downloader/helpers/show_downloader.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/library/bloc/library_bloc.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/app/stream_handler/bloc/stream_handler_bloc.dart';
import 'package:anikki/app/stream_handler/stream_handler.dart';
import 'package:anikki/app/torrent/bloc/torrent_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/domain/domain.dart';

class BlocListeners extends StatelessWidget {
  const BlocListeners({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            final settings = state.settings;

            /// Torrent listener
            final torrentBloc = BlocProvider.of<TorrentBloc>(context);

            if (torrentBloc.repository is EmptyRepository &&
                    settings.torrentType != TorrentType.none ||
                torrentBloc.repository is TransmissionRepository &&
                    settings.torrentType != TorrentType.transmission ||
                torrentBloc.repository is QBitTorrentRepository &&
                    settings.torrentType != TorrentType.qbittorrent) {
              torrentBloc.add(
                TorrentSettingsUpdated(
                  transmissionSettings:
                      settings.torrentType == TorrentType.transmission
                          ? settings.transmissionSettings
                          : null,
                  qBitTorrentSettings:
                      settings.torrentType == TorrentType.qbittorrent
                          ? settings.qBitTorrentSettings
                          : null,
                ),
              );
            }
          },
        ),
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state is! ConnectivityOnline) return;

            BlocProvider.of<AnilistAuthBloc>(context).add(
              AnilistAuthLoginRequested(),
            );
          },
        ),
        BlocListener<DownloaderBloc, DownloaderState>(
          listener: (context, state) {
            if (state is DownloaderShow && !state.alreadyShow) {
              showDownloader(context, state.term);
            }
          },
        ),
        BlocListener<StreamHandlerBloc, StreamHandlerState>(
          listener: (context, state) async {
            if (state is! StreamHandlerShowed) return;

            final streamHandlerBloc =
                BlocProvider.of<StreamHandlerBloc>(context);

            await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: StreamHandlerView(
                    state: state,
                  ),
                );
              },
            );

            streamHandlerBloc.add(
              StreamHandlerCloseRequested(
                media: state.media,
                minEpisode: state.minEpisode,
              ),
            );
          },
        ),
        BlocListener<AnilistAuthBloc, AnilistAuthState>(
          listener: (context, state) {
            final connected = state is AnilistAuthSuccess;

            BlocProvider.of<WatchListBloc>(context).add(
              WatchListAuthUpdated(
                connected: connected,
                provider: WatchListProvider.anilist,
              ),
            );

            if (!connected) {
              BlocProvider.of<HomeBloc>(context).add(
                const HomeRefreshed(
                  watchList: null,
                  requestedType: HomeMediaType.trending,
                ),
              );
            }
          },
        ),
        BlocListener<WatchListBloc, WatchListState>(
          listener: (context, state) {
            if (state is WatchListLoaded) {
              BlocProvider.of<HomeBloc>(context).add(
                HomeRefreshed(
                  watchList: state.watchList,
                  watchListProvider: state.currentProvider,
                  requestedType: state.watchList?.isNotEmpty == true
                      ? HomeMediaType.following
                      : null,
                ),
              );
            }

            if (state is! WatchListNotify) return;

            context.notify(
              message: state.title,
              descritpion: state.description,
              isError: state.isError,
            );
          },
        ),
        BlocListener<LibraryBloc, LibraryState>(
          listener: (context, state) {
            if (state is LibraryLoaded) {
              final settingsBloc = BlocProvider.of<SettingsBloc>(context);

              settingsBloc.add(
                SettingsUpdated(
                  settingsBloc.state.settings.copyWith(
                    librarySettings:
                        settingsBloc.state.settings.librarySettings.copyWith(
                      path: state.path,
                    ),
                  ),
                ),
              );
            }
          },
        )
      ],
      child: child,
    );
  }
}
