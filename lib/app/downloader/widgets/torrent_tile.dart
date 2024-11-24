import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/downloader/bloc/downloader_bloc.dart';
import 'package:anikki/app/downloader/widgets/stream_placeholder.dart';
import 'package:anikki/app/torrent/bloc/torrent_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

class TorrentTile extends StatelessWidget {
  const TorrentTile({
    super.key,
    required this.torrent,
  });

  final NyaaTorrent torrent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () async {
        final state = BlocProvider.of<DownloaderBloc>(context).state;

        final isStreaming =
            state is DownloaderSuccess ? state.isStreaming : false;
        final media = state is DownloaderSuccess ? state.media : null;

        if (!isStreaming) {
          return openInBrowser(torrent.magnet);
        }

        final bloc = BlocProvider.of<TorrentBloc>(context);

        if (bloc.state is TorrentCannotLoad) {
          return showDialog(
            context: context,
            builder: (context) {
              return PlatformAlertDialog(
                title: const Text('Torrent client not connected'),
                content: const Text(
                    'Please start your torrent client to enable streaming.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
        }

        bloc.add(
          TorrentAddTorrent(
            magnet: torrent.magnet,
            stream: true,
            callback: (Torrent torrent) async {
              Navigator.of(context).pop();

              return showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    child: StreamPlaceholder(
                      torrent: torrent,
                      media: media,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      leading: CircleAvatar(
        radius: 8.0,
        backgroundColor: torrent.status == 'success'
            ? Colors.green
            : torrent.status == 'danger'
                ? Colors.red
                : Colors.yellow,
      ),
      title: Text(torrent.name),
      subtitle: Text(torrent.filesize),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Icon(
                      HugeIcons.strokeRoundedArrowUp01,
                      color: Colors.green,
                    )),
                    TextSpan(
                        text: torrent.seeders,
                        style: const TextStyle(color: Colors.green))
                  ],
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                      child: Icon(
                    HugeIcons.strokeRoundedArrowUp01,
                    color: Colors.redAccent,
                  )),
                  TextSpan(
                      text: torrent.leechers,
                      style: const TextStyle(color: Colors.redAccent))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
