import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

enum WatchListProvider {
  anilist(
    title: 'AniList',
    icon: SimpleIcons.anilist,
    color: Color(0x0FF2A9FF),
  ),
  mal(
    title: 'MyAnimeList',
    icon: SimpleIcons.myanimelist,
    color: Color(0xFF2E51A2),
  ),
  kitsu(
    title: 'Kitsu',
    icon: SimpleIcons.kitsu,
    color: Color(0xFFFD755C),
  );

  final String title;
  final IconData icon;
  final Color color;

  const WatchListProvider({
    required this.title,
    required this.icon,
    required this.color,
  });
}
