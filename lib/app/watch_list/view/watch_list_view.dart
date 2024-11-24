import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/provider_auth/provider_auth.dart';
import 'package:anikki/app/provider_auth/shared/helpers/logout.dart';
import 'package:anikki/app/watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/watch_list/widgets/watch_list_card.dart';
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

            if (provider == null) return const SizedBox();

            final initial = state is WatchListInitial;
            final errored = state is WatchListError;
            final loading = state is WatchListLoading;

            final actions = [
              if (loading)
                const SectionTitleLoadingAction()
              else if (connected || errored)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: () async {
                      BlocProvider.of<WatchListBloc>(context).add(
                        WatchListRequested(
                          provider: state.currentProvider ??
                              WatchListProvider.values.first,
                        ),
                      );
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
                    tooltip: 'Logout of ${provider.title}',
                    onPressed: () => logoutFromAnilist(context),
                    icon:
                        const AnikkiIcon(icon: HugeIcons.strokeRoundedLogout02),
                  ),
                ),
              ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                isSelected:
                    state.connected.values.every((value) => value == false) &&
                            state.currentProvider == null
                        ? [true, false, false]
                        : WatchListProvider.values
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

            Widget body = Center(
              child: ProviderAuthView(
                provider: provider,
              ),
            );

            if (loading && state.isEmpty) {
              body = Center(
                child: LoadingWidget(),
              );
            } else {
              if (state.isEmpty && errored) {
                body = Center(
                  child: CustomErrorWidget(
                    title: 'Could not load Watch list',
                    description: state.message,
                  ),
                );
              } else if (!connected || initial) {
                body = Center(
                  child: ProviderAuthView(
                    provider: provider,
                  ),
                );
              } else if (state.isNotEmpty) {
                body = _WatchListCompleteView(state);
              }
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                  ),
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
                Expanded(
                  child: body,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
