import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/list_view/custom_list_view.dart';
import 'package:anikki/core/widgets/grid_view/custom_grid_view.dart';
import 'package:anikki/app/news/widgets/news_tile.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/app/news/widgets/news_card.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({super.key, required this.entries});

  final List<NewsEntry> entries;

  @override
  Widget build(BuildContext context) {
    final settings =
        BlocProvider.of<SettingsBloc>(context, listen: true).state.settings;

    return NewsLayouts.grid == settings.newsLayout
        ? CustomGridView(
            entries: entries,
            builder: (entry, index) => NewsCard(entry: entry),
          )
        : CustomListView(
            entries: entries,
            builder: (context, entry) => NewsTile(entry: entry),
          );
  }
}