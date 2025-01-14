import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';

class SearchViewContainer extends StatelessWidget {
  const SearchViewContainer({
    super.key,
    required this.child,
    this.isEmpty = true,
  });

  final bool isEmpty;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(builder: (context, state) {
      final landscape = state is LayoutLandscape;
      if (landscape) {
        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: child,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: child,
        );
      }
    });
  }
}
