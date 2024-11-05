import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/search/bloc/search_bloc.dart';
import 'package:anikki/app/search/widgets/anikki_search_bar.dart';
import 'package:anikki/app/search/widgets/search_container.dart';
import 'package:anikki/app/search/widgets/search_results.dart';
import 'package:anikki/core/widgets/empty_widget.dart';
import 'package:anikki/core/widgets/error_widget.dart';
import 'package:anikki/core/widgets/loading_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SearchViewContainer(
          isEmpty: state is SearchEmptyTerm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnikkiSearchBar(),
              if (state is! SearchEmptyTerm) const Divider(),
              if (state is SearchLoading)
                const Expanded(
                  child: Center(
                    child: LoadingWidget(),
                  ),
                ),
              if (state is SearchSuccess)
                state.isEmpty
                    ? const Center(
                        child: EmptyWidget(
                          title: 'Could not find anything...',
                          width: 300,
                        ),
                      )
                    : Expanded(
                        child: SearchResults(
                          state: state,
                        ),
                      ),
              if (state is SearchError)
                Center(
                  child: CustomErrorWidget(
                    description: state.message,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
