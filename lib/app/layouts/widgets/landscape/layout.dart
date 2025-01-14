import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/layouts/shared/helpers/page.dart';
import 'package:anikki/app/layouts/widgets/landscape/drawer_content/drawer_content.dart';
import 'package:anikki/app/layouts/widgets/landscape/navigation_rail.dart';
import 'package:anikki/app/search/view/search_view.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/macos_title_bar.dart';

class LandscapeLayout extends StatefulWidget {
  const LandscapeLayout({
    super.key,
    required this.pageController,
    required this.pages,
    required this.onPageChanged,
    required this.connected,
  });

  final PageController pageController;
  final List<AnikkiPage> pages;
  final void Function(int index) onPageChanged;
  final bool connected;

  @override
  State<LandscapeLayout> createState() => _LandscapeLayoutState();
}

class _LandscapeLayoutState extends State<LandscapeLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            drawer: Drawer(
              width: (MediaQuery.of(context).size.width / 3).clamp(550, 1000),
              child: const SearchView(),
            ),
            endDrawer: Drawer(
              width: (MediaQuery.of(context).size.width / 2).clamp(750, 1250),
              child: const DrawerContent(),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Row(
                      children: [
                        AnikkiNavigationRail(
                          pages: widget.pages,
                          currentIndex: currentIndex,
                          onPageChanged: widget.onPageChanged,
                          connected: widget.connected,
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                              ),
                              border: Border.all(
                                color: context.colorScheme.outlineVariant,
                              ),
                            ),
                            child: PageView(
                              controller: widget.pageController,
                              onPageChanged: (value) {
                                setState(() {
                                  currentIndex = value;
                                });
                              },
                              children: widget.pages
                                  .map((page) => page.child)
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (Platform.isMacOS) const MacosTitleBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
