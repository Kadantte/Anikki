import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/user_list_layout_toggle.dart';
import 'package:anikki/core/widgets/loader.dart';
import 'package:anikki/core/widgets/anikki_icon.dart';
import 'package:anikki/core/widgets/layout_card.dart';
import 'package:anikki/core/widgets/error_tile.dart';
import 'package:anikki/data/data.dart';
import 'package:anikki/app/anilist_auth/anilist_auth.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/anilist_watch_list/view/watch_list_layout.dart';
import 'package:ionicons/ionicons.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      vsync: this,
      length: Enum$MediaListStatus.values.length - 1,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutCard(
      child: Column(
        children: [
          AppBar(
            title: const Text('Watch Lists'),
            actions: [
              const UserListLayoutToggle(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  onPressed: () async {
                    final state =
                        BlocProvider.of<AnilistAuthBloc>(context).state;

                    if (state is AnilistAuthSuccess) {
                      BlocProvider.of<WatchListBloc>(context).add(
                        WatchListRequested(username: state.me.name),
                      );
                    }
                  },
                  icon: const AnikkiIcon(icon: Ionicons.refresh_outline),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Tooltip(
                  message: 'Logout of Anilist',
                  child: IconButton(
                    onPressed: () async {
                      BlocProvider.of<AnilistAuthBloc>(context)
                          .add(AnilistAuthLogoutRequested());

                      Navigator.of(context).pop();
                    },
                    icon: const AnikkiIcon(icon: Ionicons.log_out_outline),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<WatchListBloc, WatchListState>(
                builder: (context, state) {
              switch (state.runtimeType) {
                case WatchListInitial:
                  return const Center(child: AnilistAuthView());
                case WatchListLoading:
                  return const Loader();
                case WatchListComplete:
                  final entries = (state as WatchListComplete).watchList;

                  return Column(
                    children: [
                      TabBar(
                        isScrollable: MediaQuery.of(context).size.width < 600,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1.0,
                        splashBorderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        tabs: Enum$MediaListStatus.values
                            .where((element) => element.name != '\$unknown')
                            .map(
                              (e) => Tab(
                                text: e.name.capitalize(),
                              ),
                            )
                            .toList(),
                        controller: controller,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: controller,
                          children: Enum$MediaListStatus.values
                              .where((element) => element.name != '\$unknown')
                              .map(
                                (status) => WatchListLayout(
                                  entries: entries[status] ?? [],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );

                case WatchListError:
                  final message = (state as WatchListError).message;
                  return ErrorTile(
                    title: 'Could not retrieve watch list.',
                    description: message,
                  );
                default:
                  return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }
}
