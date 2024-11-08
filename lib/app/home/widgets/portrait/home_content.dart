import 'dart:math';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'package:anikki/app/downloader/bloc/downloader_bloc.dart';
import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/layouts/widgets/landscape/drawer_content/drawer_content.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/loading_widget.dart';
import 'package:anikki/domain/video_player_repository.dart';

part 'home_actions.dart';
part 'home_carousel.dart';
part 'home_information.dart';
part 'home_subtitle.dart';
part 'home_title.dart';
part 'home_title_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final initial = state is HomeInitial;
        final loading = state is HomeLoading;
        final errored = state is HomeError;

        if (initial || loading) {
          return Center(
            child: LoadingWidget(),
          );
        }

        if (errored && state.entries.isEmpty) {
          return Center(
            child: CustomErrorWidget(
              description: state.message,
            ),
          );
        }

        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (!details.globalPosition.dy.isNegative) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => Material(child: const DrawerContent()),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _HomeCarousel(
                  entries: state.entries,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 52.0,
                    right: 52.0,
                    bottom: 72.0,
                  ),
                  child: _HomeTitleCard(
                    media: state.currentMedia,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
