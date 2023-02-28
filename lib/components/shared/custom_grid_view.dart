import 'package:anikki/library/library_card.dart';
import 'package:anilist/anilist.dart';
import 'package:flutter/material.dart';

import 'package:anikki/components/news/news_card.dart';
import 'package:anikki/components/user_list/watch_list/watch_list_card.dart';
import 'package:anikki/models/local_file.dart';

class CustomGridView<T> extends StatelessWidget {
  final List<T> entries;

  const CustomGridView({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: entries.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];

        if (T == ScheduleEntry) {
          return NewsCard(entry: entry as ScheduleEntry);
        }

        if (T == LocalFile) {
          return LocalCard(entry: entry as LocalFile);
        }

        if (T == AnilistListEntry) {
          return WatchListCard(entry: entry as AnilistListEntry);
        }

        return const SizedBox();
      },
    );
  }
}
