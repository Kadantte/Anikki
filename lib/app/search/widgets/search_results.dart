import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:anikki/app/downloader/widgets/torrents_list.dart';
import 'package:anikki/app/library/widgets/library_card.dart';
import 'package:anikki/app/search/bloc/search_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/entry/entry_tile.dart';
import 'package:anikki/core/widgets/grid_view/custom_grid_view.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({
    super.key,
    required this.state,
  });

  final SearchSuccess state;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late List<Tab> tabs;

  @override
  void initState() {
    super.initState();

    tabs = [
      if (widget.state.medias != null && widget.state.medias!.isNotEmpty)
        const Tab(
          text: 'Animes',
        ),
      if (widget.state.torrents != null && widget.state.torrents!.isNotEmpty)
        const Tab(
          text: 'Torrents',
        ),
      if (widget.state.libraryEntries != null &&
          widget.state.libraryEntries!.isNotEmpty)
        const Tab(
          text: 'Local files',
        ),
      if (widget.state.staffs != null && widget.state.staffs!.isNotEmpty)
        const Tab(
          text: 'Staff',
        ),
      if (widget.state.characters != null &&
          widget.state.characters!.isNotEmpty)
        const Tab(
          text: 'Characters',
        ),
    ];

    controller = TabController(
      vsync: this,
      length: tabs.length,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          isScrollable: MediaQuery.of(context).size.width < 600,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 1.0,
          splashBorderRadius: const BorderRadius.all(Radius.circular(40)),
          controller: controller,
          tabs: tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              if (widget.state.medias != null &&
                  widget.state.medias!.isNotEmpty)
                ListView(
                  children: widget.state.medias!
                      .map(
                        (e) => EntryTile(
                          media: Media(anilistInfo: e),
                        ),
                      )
                      .toList(),
                ),
              if (widget.state.torrents != null &&
                  widget.state.torrents!.isNotEmpty)
                TorrentsList(
                  torrents: widget.state.torrents!,
                ),
              if (widget.state.libraryEntries != null &&
                  widget.state.libraryEntries!.isNotEmpty)
                CustomGridView(
                  entries: widget.state.libraryEntries!,
                  gridDelegate: userListGridDelegate,
                  builder: (entry, index) => LibraryCard(
                    entry: entry,
                  ),
                ),
              if (widget.state.staffs != null &&
                  widget.state.staffs!.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.state.staffs!.length,
                  itemBuilder: (context, index) {
                    final item = widget.state.staffs![index];

                    return ListTile(
                      title: Text(item.name?.full ?? 'N/A'),
                      subtitle: const Text(''),
                      onTap: () => openInBrowser(item.siteUrl),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            item.image?.large ?? item.image?.medium ?? ''),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                ),
              if (widget.state.characters != null &&
                  widget.state.characters!.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.state.characters!.length,
                  itemBuilder: (context, index) {
                    final item = widget.state.characters![index];

                    return ListTile(
                      title: Text(item.name?.full ?? 'N/A'),
                      subtitle: const Text(''),
                      onTap: () => openInBrowser(item.siteUrl),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            item.image?.large ?? item.image?.medium ?? ''),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
