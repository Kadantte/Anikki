import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/features/torrent/presentation/bloc/torrent_bloc.dart';
import 'package:anikki/features/torrent/domain/domain.dart';
import 'package:anikki/features/qbittorrent/presentation/bloc/qbittorrent_bloc.dart';
import 'package:anikki/features/qbittorrent/presentation/view/qbittorrent_view.dart';
import 'package:anikki/core/widgets/error_tile.dart';

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
      create: (context) => QBitTorrentBloc(
        wrapper.qBitTorrent,
        BlocProvider.of<TorrentBloc>(context),
      ),
      child: const QBitTorrentView(),
    );
  }
}