import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/home/bloc/home_bloc.dart';
import 'package:anikki/app/home/widgets/portrait/home_app_bar_content.dart';
import 'package:anikki/app/home/widgets/portrait/home_content.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeViewPortrait extends StatefulWidget {
  const HomeViewPortrait({
    super.key,
    required this.isWatchListLoading,
  });

  final bool isWatchListLoading;

  @override
  State<HomeViewPortrait> createState() => _HomeViewPortraitState();
}

class _HomeViewPortraitState extends State<HomeViewPortrait>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: HomeMediaType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 45,
            title: const HomeAppBarContent(),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                iconSize: 20.0,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(
                    HomeRefreshed(),
                  );
                },
                icon: Icon(
                  HugeIcons.strokeRoundedRefresh,
                ),
              ),
            ],
          ),
          body: HomeContent(),
        );
      },
    );
  }
}
