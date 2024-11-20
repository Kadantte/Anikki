import 'package:flutter/material.dart';

import 'package:anikki/core/core.dart';

import 'path.dart';

const settings = Settings(
  isFirstLaunch: false,
  theme: ThemeMode.system,
  torrentType: TorrentType.none,
  librarySettings: LibrarySettings(path: path),
  transmissionSettings: TransmissionSettings(),
  qBitTorrentSettings: QBitTorrentSettings(),
  videoPlayerSettings: VideoPlayerSettings(),
);
