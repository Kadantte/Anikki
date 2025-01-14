import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/core/core.dart';

class HomeSideMenuAction {
  HomeSideMenuAction({
    required this.type,
    required this.icon,
  });

  final HomeMediaType type;
  final IconData icon;
}

List<HomeSideMenuAction> _buildActions(bool hasList) => <HomeSideMenuAction>[
      HomeSideMenuAction(
        type: HomeMediaType.trending,
        icon: HugeIcons.strokeRoundedFire,
      ),
      HomeSideMenuAction(
        type: HomeMediaType.recommendations,
        icon: HugeIcons.strokeRoundedThumbsUp,
      ),
      if (hasList)
        HomeSideMenuAction(
          type: HomeMediaType.toStart,
          icon: HugeIcons.strokeRoundedBookmarkAdd02,
        ),
      if (hasList)
        HomeSideMenuAction(
          type: HomeMediaType.following,
          icon: HugeIcons.strokeRoundedAllBookmark,
        ),
    ];

class HomeSideMenu extends StatelessWidget {
  const HomeSideMenu({
    super.key,
    required this.loading,
  });

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: context.colorScheme.surface.withOpacity(0.2),
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return BlocBuilder<WatchListBloc, WatchListState>(
                builder: (context, watchListState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state is HomeError)
                        Tooltip(
                          message: state.message,
                          child: Icon(
                            HugeIcons.strokeRoundedAlert02,
                            size: 26,
                            color: context.colorScheme.error,
                          ),
                        ),
                      for (final action in _buildActions(
                        watchListState.connected.values.any(
                              (connected) => connected,
                            ) &&
                            watchListState.isNotEmpty,
                      )) ...[
                        IconButton(
                          tooltip: 'Show ${action.type.title}',
                          iconSize: 26,
                          color: state.type == action.type
                              ? context.colorScheme.primary
                              : null,
                          onPressed: () {
                            final watchListBloc =
                                BlocProvider.of<WatchListBloc>(context);

                            BlocProvider.of<HomeBloc>(context).add(
                              HomeRefreshed(
                                requestedType: action.type,
                                watchList: watchListBloc.state.watchList,
                              ),
                            );
                          },
                          icon: Icon(action.icon),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                      AnimatedCrossFade(
                        firstChild: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: context.colorScheme.onPrimary,
                            strokeWidth: 2.0,
                          ),
                        ),
                        secondChild: IconButton(
                          iconSize: 26,
                          onPressed: () {
                            final watchListBloc =
                                BlocProvider.of<WatchListBloc>(context);

                            if (watchListBloc.state
                                    .connected[WatchListProvider.anilist] ==
                                true) {
                              watchListBloc.add(
                                WatchListRequested(
                                  provider: WatchListProvider.anilist,
                                ),
                              );
                            } else {
                              BlocProvider.of<HomeBloc>(context).add(
                                const HomeRefreshed(),
                              );
                            }
                          },
                          icon: const Icon(HugeIcons.strokeRoundedRefresh),
                        ),
                        crossFadeState: loading
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
