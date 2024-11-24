import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:window_manager/window_manager.dart';

import 'package:anikki/anikki.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/domain/domain.dart';

mixin ProviderAuthMixin on State<Anikki>, ProtocolListener {
  final availableHosts = [
    'anilist-auth',
    'mal-auth',
  ];

  @override
  void initState() {
    protocolHandler.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    protocolHandler.removeListener(this);
    super.dispose();
  }

  @override
  void onProtocolUrlReceived(String url) async {
    final uri = Uri.parse(url.replaceFirst('#', '?'));

    /// On `anikki://anilist-auth?blabla=hello`
    ///
    /// final scheme = uri.scheme; // anikki
    /// final host = uri.host; // anilist-auth
    /// final query = uri.query; // blabla=hello
    /// final params = uri.queryParameters; // {blabla: hello}

    if (!availableHosts.contains(uri.host)) return;

    final provider = switch (uri.host) {
      'anilist-auth' => WatchListProvider.anilist,
      'mal-auth' => WatchListProvider.mal,
      _ => throw UnimplementedError(),
    };

    final token = switch (provider) {
      WatchListProvider.anilist => uri.queryParameters['access_token'],
      WatchListProvider.mal => 'code=${uri.queryParameters['code']}',
      WatchListProvider.kitsu => throw UnimplementedError(),
    };

    final box = await Hive.openBox(UserRepository.boxName);
    await box.put(UserRepository.tokenKey[provider], token);

    if (isDesktop()) {
      windowManager.focus();
    }
  }
}
