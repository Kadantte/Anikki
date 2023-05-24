import 'package:anilist/anilist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/features/settings/bloc/settings_bloc.dart';
import 'package:anikki/features/settings/models/settings.dart';
import 'package:anikki/widgets/entry/entry_tile.dart';
import 'package:anikki/features/watch_list/widgets/watch_list_card.dart';
import 'package:anikki/widgets/list_view/custom_list_view.dart';
import 'package:anikki/widgets/grid_view/custom_grid_view.dart';
import 'package:anikki/user_list/user_list_grid_delegate.dart';

class WatchListLayout extends StatelessWidget {
  const WatchListLayout({super.key, required this.entries});

  final List<Query$GetLists$MediaListCollection$lists$entries> entries;

  @override
  Widget build(BuildContext context) {
    final layout = BlocProvider.of<SettingsBloc>(context, listen: true)
        .state
        .settings
        .userListLayouts;

    return layout == UserListLayouts.grid
        ? CustomGridView(
            entries: entries,
            gridDelegate: userListGridDelegate,
            builder: (entry, index) => WatchListCard(entry: entry),
          )
        : CustomListView(
            entries: entries,
            builder: (context, entry) => EntryTile(
              media: entry.media!,
              subtitle: entry.status == Enum$MediaListStatus.CURRENT &&
                      entry.progress != null
                  ? Text('Currently at episode ${entry.progress!.toString()}')
                  : (entry.status != Enum$MediaListStatus.CURRENT &&
                          entry.notes != null)
                      ? Text(entry.notes!)
                      : const SizedBox(),
            ),
          );
  }
}
