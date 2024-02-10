import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import 'package:anikki/app/anilist_auth/anilist_auth.dart';
import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/anilist_watch_list/bloc/watch_list_bloc.dart';
import 'package:anikki/app/anilist_watch_list/view/watch_list_layout.dart';
import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/anikki_icon.dart';
import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/layout_card.dart';
import 'package:anikki/core/widgets/loader.dart';
import 'package:anikki/core/widgets/user_list_layout_toggle.dart';
import 'package:anikki/data/data.dart';

part 'watch_list_complete_view.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      const UserListLayoutToggle(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IconButton(
          onPressed: () async {
            final state = BlocProvider.of<AnilistAuthBloc>(context).state;

            if (state is AnilistAuthSuccess) {
              BlocProvider.of<WatchListBloc>(context).add(
                WatchListRequested(username: state.me.name),
              );
            }
          },
          icon: const AnikkiIcon(icon: Ionicons.refresh_outline),
        ),
      ),
      BlocBuilder<AnilistAuthBloc, AnilistAuthState>(
        builder: (context, state) {
          if (state is! AnilistAuthSuccess) return const SizedBox();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Tooltip(
              message: 'Logout of Anilist',
              child: IconButton(
                onPressed: () async {
                  BlocProvider.of<AnilistAuthBloc>(context)
                      .add(AnilistAuthLogoutRequested());

                  if (BlocProvider.of<LayoutBloc>(context).state
                      is LayoutLandscape) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const AnikkiIcon(icon: Ionicons.log_out_outline),
              ),
            ),
          );
        },
      ),
    ];

    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        final portrait = state is LayoutPortrait;

        return LayoutCard(
          transparent: portrait,
          child: Column(
            children: [
              if (portrait)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                )
              else
                AppBar(
                  title: const Text('Watch Lists'),
                  actions: actions,
                ),
              Expanded(
                child: BlocBuilder<WatchListBloc, WatchListState>(
                  builder: (context, state) => switch (state) {
                    WatchListError() => Center(
                        child: CustomErrorWidget(
                          title: 'Could not load Watch list',
                          description: state.message,
                        ),
                      ),
                    WatchListInitial() => const Center(
                        child: AnilistAuthView(),
                      ),
                    WatchListLoading() => const Loader(),
                    WatchListComplete() => _WatchListCompleteView(state),
                    WatchListNotify() => const SizedBox(),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
