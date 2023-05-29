import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/features/torrent/models/qbittorrent_wrapper.dart';
import 'package:anikki/features/qbittorrent/bloc/qbittorrent_bloc.dart';
import 'package:anikki/features/qbittorrent/view/qbittorrent_view.dart';
import 'package:anikki/widgets/error_tile.dart';

class QBitTorrentPage extends StatelessWidget {
  const QBitTorrentPage({
    super.key,
    required this.wrapper,
  });

  final QBitTorrentWrapper wrapper;

  @override
  Widget build(BuildContext context) {
    if (!wrapper.isAuthorized) {
      return const ErrorTile(
        title: 'Cannot log into QBitTorrent client',
        description: 'Please enter the right credentials in the settings.',
      );
    }

    return BlocProvider(
      create: (context) => QBitTorrentBloc(wrapper.qBitTorrent),
      child: const QBitTorrentView(),
    );
  }
}
