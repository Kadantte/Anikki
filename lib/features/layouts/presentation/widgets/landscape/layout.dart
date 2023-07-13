import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/core/widgets/layout_card.dart';
import 'package:anikki/features/entry_card_overlay/presentation/bloc/entry_card_overlay_bloc.dart';
import 'package:anikki/features/entry_card_overlay/presentation/view/entry_card_overlay_view.dart';
import 'package:anikki/features/torrent/torrent.dart';
import 'package:anikki/features/layouts/presentation/widgets/landscape/custom_app_bar.dart';
import 'package:anikki/features/user_list/presentation/view/user_list_view.dart';
import 'package:anikki/features/news/news.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({
    Key? key,
  }) : super(key: key);

  final borderRadius = const BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: UserListView(),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: LayoutCard(
                              child: NewsPage(
                                showOutline: true,
                              ),
                            ),
                          ),
                          TorrentView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<EntryCardOverlayBloc, EntryCardOverlayState>(
            builder: (context, state) {
          if (state is! EntryCardOverlayActive) return const SizedBox();

          return EntryCardOverlayView(
            media: state.media,
            anchorKey: state.key,
            isExpanded: state.isExpanded,
          );
        })
      ],
    );
  }
}
