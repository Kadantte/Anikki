import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/torrent/bloc/torrent_bloc.dart';
import 'package:anikki/core/core.dart';

class TorrentTile extends StatelessWidget {
  const TorrentTile({
    super.key,
    required this.torrent,
  });

  final Torrent torrent;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TorrentBloc>(context);
    final progress = torrent.progress;

    return ListTile(
      dense: true,
      title: Text(torrent.name),
      subtitle: Text(torrent.status),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: progress == 1.0 ? Colors.green : null,
            ),
            Center(
              child: Text(
                '${(progress * 100).floor()}%',
                style: const TextStyle(fontSize: 8.0),
              ),
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (['Stopped', 'Paused'].contains(torrent.status))
            IconButton.outlined(
              constraints: const BoxConstraints(),
              iconSize: 20.0,
              onPressed: () {
                bloc.add(
                  TorrentStartTorrent(torrent),
                );
              },
              icon: const Icon(HugeIcons.strokeRoundedReload),
            )
          else
            IconButton.outlined(
              constraints: const BoxConstraints(),
              iconSize: 20.0,
              onPressed: () {
                bloc.add(
                  TorrentPauseTorrent(torrent),
                );
              },
              icon: const Icon(HugeIcons.strokeRoundedPause),
            ),
          const SizedBox(
            width: 4.0,
          ),
          IconButton.outlined(
            constraints: const BoxConstraints(),
            iconSize: 20.0,
            onPressed: () {
              bloc.add(
                TorrentRemoveTorrent(
                  torrent,
                  progress != 1.0,
                ),
              );
            },
            icon: const Icon(HugeIcons.strokeRoundedCancel01),
          ),
        ],
      ),
    );
  }
}
