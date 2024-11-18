import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeAppBarContent extends StatelessWidget {
  const HomeAppBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final connected =
        BlocProvider.of<AnilistAuthBloc>(context, listen: true).isConnected;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SegmentedButton(
          multiSelectionEnabled: false,
          emptySelectionAllowed: false,
          selectedIcon: const SizedBox(),
          segments: [
            for (final type in HomeMediaType.values.where((value) =>
                connected ||
                [HomeMediaType.trending, HomeMediaType.recommendations]
                    .contains(value)))
              ButtonSegment(
                value: type,
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    switch (type) {
                      HomeMediaType.following =>
                        HugeIcons.strokeRoundedAllBookmark,
                      HomeMediaType.toStart =>
                        HugeIcons.strokeRoundedBookmarkAdd02,
                      HomeMediaType.trending => HugeIcons.strokeRoundedFire,
                      HomeMediaType.recommendations =>
                        HugeIcons.strokeRoundedThumbsUp,
                    },
                  ),
                ),
                tooltip: switch (type) {
                  HomeMediaType.following => 'Following',
                  HomeMediaType.toStart => 'To start',
                  HomeMediaType.trending => 'Trending',
                  HomeMediaType.recommendations => 'Recommended',
                },
              ),
          ],
          selected: {state.type},
          onSelectionChanged: (selection) {
            final requestedType = selection.first;
            final watchListBloc = BlocProvider.of<WatchListBloc>(context);

            BlocProvider.of<HomeBloc>(context).add(
              HomeRefreshed(
                requestedType: requestedType,
                watchList: watchListBloc.state.watchList,
              ),
            );
          },
        );
      },
    );
  }
}
