import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/anilist_auth/anilist_auth.dart';
import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/anilist_auth/shared/helpers/logout.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/anilist_watch_list/widgets/watch_list_card.dart';
import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/anikki_icon.dart';
import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/grid_view/custom_grid_view.dart';
import 'package:anikki/core/widgets/loading_widget.dart';
import 'package:anikki/core/widgets/section/section_title.dart';
import 'package:anikki/core/widgets/section/section_title_loading_action.dart';
import 'package:anikki/data/data.dart';

part 'watch_list_complete_view.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        final portrait = state is LayoutPortrait;

        return BlocBuilder<WatchListBloc, WatchListState>(
          builder: (context, state) {
            final provider = state.currentProvider;
            final connected = state.connected[provider] ?? false;

            final initial = state is WatchListInitial;
            final errored = state is WatchListError;
            final loading = state is WatchListLoading;

            final actions = [
              if (loading)
                const SectionTitleLoadingAction()
              else if (connected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: () async {
                      final state =
                          BlocProvider.of<AnilistAuthBloc>(context).state;

                      if (state is AnilistAuthSuccess) {
                        BlocProvider.of<WatchListBloc>(context).add(
                          WatchListRequested(
                            provider: WatchListProvider.anilist,
                          ),
                        );
                      }
                    },
                    icon: const AnikkiIcon(
                      icon: HugeIcons.strokeRoundedRefresh,
                    ),
                  ),
                ),
              if (connected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    tooltip: 'Logout of ${provider?.title}',
                    onPressed: () => logoutFromAnilist(context),
                    icon:
                        const AnikkiIcon(icon: HugeIcons.strokeRoundedLogout02),
                  ),
                ),
              ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                isSelected: WatchListProvider.values
                    .map((value) => value == provider)
                    .toList(),
                onPressed: (index) {
                  BlocProvider.of<WatchListBloc>(context).add(
                    WatchListCurrentProviderUpdated(
                      provider: WatchListProvider.values.elementAt(index),
                    ),
                  );
                },
                children: [
                  for (final watchListProvider in WatchListProvider.values)
                    Tooltip(
                      verticalOffset: 32.0,
                      message: watchListProvider.title,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: Icon(
                          watchListProvider.icon,
                          color: watchListProvider.color,
                        ),
                      ),
                    ),
                ],
              ),
            ];

            final authView = Expanded(
              child: Center(
                child: switch (provider) {
                  null => throw UnimplementedError(),
                  WatchListProvider.anilist => const AnilistAuthView(),
                  WatchListProvider.mal => CustomErrorWidget(
                      title: 'Cannot connect with ${provider.title}',
                      description:
                          'This feature is not implemented yet, it is coming soon!',
                    ),
                  WatchListProvider.kitsu => CustomErrorWidget(
                      title: 'Cannot connect with ${provider.title}',
                      description:
                          'This feature is not implemented yet, it is coming soon!',
                    ),
                },
              ),
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      if (!portrait)
                        SectionTitle(
                          text: 'Watch Lists',
                        ),
                      const Spacer(),
                      ...actions,
                    ],
                  ),
                ),
                const Divider(),
                if (!loading && errored && state.isEmpty)
                  Expanded(
                    child: CustomErrorWidget(
                      title: 'Could not load Watch list',
                      description: state.message,
                    ),
                  ),
                if (!errored && loading && state.isEmpty && !connected ||
                    (loading && !connected))
                  const Expanded(
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  ),
                if (!connected || initial)
                  authView
                else if (state.isNotEmpty)
                  Expanded(
                    child: _WatchListCompleteView(state),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
