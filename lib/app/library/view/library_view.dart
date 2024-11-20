import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/library/bloc/library_bloc.dart';
import 'package:anikki/app/library/widgets/library_card.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/anikki_action_button.dart';
import 'package:anikki/core/widgets/empty_widget.dart';
import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/grid_view/custom_grid_view.dart';
import 'package:anikki/core/widgets/loading_widget.dart';
import 'package:anikki/core/widgets/section/section_title.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final actionButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnikkiActionButton(
        actions: [
          AnikkiAction(
            icon: HugeIcons.strokeRoundedFolderTransfer,
            label: 'Change folder',
            callback: (_) {
              final settingsBloc = BlocProvider.of<SettingsBloc>(context);

              BlocProvider.of<LibraryBloc>(context).add(
                LibraryUpdateRequested(
                  onUpdated: (path) => settingsBloc.add(
                    SettingsUpdated(
                      settingsBloc.state.settings.copyWith(
                        librarySettings: settingsBloc
                            .state.settings.librarySettings
                            .copyWith(
                          path: path,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnikkiAction(
            icon: HugeIcons.strokeRoundedLinkCircle,
            label: Platform.isMacOS ? 'Open in Finder' : 'Open in Explorer',
            callback: openFolderInExplorer,
          ),
        ],
      ),
    );

    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        final portrait = state is LayoutPortrait;

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  if (!portrait)
                    SectionTitle(
                      text: 'Library',
                    ),
                  const Spacer(),
                  actionButton,
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<LibraryBloc, LibraryState>(
                builder: (context, state) => switch (state) {
                  LibraryLoading() || LibraryInitial() => const Center(
                      child: LoadingWidget(),
                    ),
                  LibraryError() => Center(
                      child: CustomErrorWidget(
                        title: 'Could not load your files at ${state.path}',
                        description: state.message,
                      ),
                    ),
                  LibraryEmpty() => const Center(
                      child: EmptyWidget(
                        title: 'No File',
                        subtitle: 'Could not find any video',
                      ),
                    ),
                  LibraryLoaded() => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: CustomGridView(
                        entries: state.entries,
                        gridDelegate: userListGridDelegate,
                        builder: (entry, index) => LibraryCard(
                          entry: entry,
                        ),
                      ),
                    ),
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
