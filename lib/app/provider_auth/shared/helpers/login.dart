import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:pkce/pkce.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anikki/app/provider_auth/bloc/provider_auth_bloc.dart';
import 'package:anikki/app/provider_auth/widgets/token_input.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/connected_dialog.dart';
import 'package:anikki/domain/domain.dart';

Future<void> loginToProvider(
  WatchListProvider provider,
  BuildContext context,
) async {
  await switch (provider) {
    WatchListProvider.anilist => _loginToAnilist(context),
    WatchListProvider.mal => _loginToMal(context),
    WatchListProvider.kitsu => throw UnimplementedError(),
  };
}

Future<void> _showConnected(
  BuildContext context,
  WatchListProvider provider,
) async {
  return showDialog(
    context: context,
    builder: (context) => ProviderConnectedDialog(
      provider: provider,
    ),
  );
}

Future<void> _loginToAnilist(BuildContext context) async {
  const provider = WatchListProvider.anilist;
  final authBloc = BlocProvider.of<ProviderAuthBloc>(context);
  final box = await Hive.openBox(UserRepository.boxName);

  final oauthUrl = Uri(
    scheme: 'https',
    host: 'anilist.co',
    path: '/api/v2/oauth/authorize',
    queryParameters: {
      'client_id': dotenv.env['ANILIST_ID'],
      'response_type': 'token',
    },
  );

  final oauthUrlLinux = Uri(
    scheme: 'https',
    host: 'anilist.co',
    path: '/api/v2/oauth/authorize',
    queryParameters: {
      'client_id': dotenv.env['ANILIST_ID_LINUX'],
      'response_type': 'token',
    },
  );

  if (Platform.isLinux) {
    launchUrl(
      oauthUrlLinux,
      mode: LaunchMode.externalApplication,
    );

    if (context.mounted) {
      await showDialog(
        barrierColor: context.colorScheme.surface.withOpacity(0.8),
        context: context,
        builder: (context) => const TokenInput(),
      );

      authBloc.add(ProviderAuthLoginRequested(provider));
    }

    return;
  }

  box.watch(key: UserRepository.tokenKey[provider]).listen((event) {
    if (event.value == null || event.deleted) return;

    authBloc.add(ProviderAuthLoginRequested(provider));

    if (context.mounted) {
      _showConnected(context, provider);
    }
  });

  launchUrl(oauthUrl, mode: LaunchMode.externalApplication);
}

Future<void> _loginToMal(BuildContext context) async {
  const provider = WatchListProvider.mal;
  final boxKey = UserRepository.tokenKey[provider];

  logger.info('Login requested for ${provider.title}');

  final authBloc = BlocProvider.of<ProviderAuthBloc>(context);
  final box = await Hive.openBox(UserRepository.boxName);

  final appId = dotenv.env['MAL_ID'];

  if (appId == null) {
    throw Exception('No MAL_ID found in environement variables');
  }

  final pkcePair = PkcePair.generate(length: 64);

  final authorizationUrl = Uri(
    host: 'myanimelist.net',
    path: 'v1/oauth2/authorize',
    scheme: 'https',
    queryParameters: {
      'response_type': 'code',
      'client_id': appId,
      'code_challenge': pkcePair.codeChallenge,
      'code_challenge_method': 'plain',
      'redirect_uri': 'anikki://mal-auth',
    },
  );

  Future<void> onMalAuthKeyUpdated(BoxEvent event) async {
    if (event.value == null || event.deleted) return;

    final value = event.value as String;
    final isCode = value.startsWith('code=');

    if (!isCode) return;

    final code = value.substring(5);

    final response = await post(
      Uri(
        host: 'myanimelist.net',
        path: 'v1/oauth2/token',
        scheme: 'https',
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': appId,
        'client_secret': '',
        'code': code,
        'code_verifier': pkcePair.codeChallenge,
        'grant_type': "authorization_code",
        'redirect_uri': 'anikki://mal-auth',
      },
    );

    final parsedBody = jsonDecode(response.body);
    parsedBody['issued_at'] = DateTime.now().millisecondsSinceEpoch;

    final box = await Hive.openBox(UserRepository.boxName);
    await box.put(boxKey, jsonEncode(parsedBody));

    authBloc.add(ProviderAuthLoginRequested(provider));

    if (context.mounted) {
      _showConnected(context, provider);
    }
  }

  box.watch(key: boxKey).listen(onMalAuthKeyUpdated);

  launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);
}
