import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anikki/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/anilist_auth/view/anilist_auth_view.dart';

mixin AnilistAuthMixin on State<AnilistAuthView>, ProtocolListener {
  final availableHosts = [
    'anilist-auth',
  ];

  final oauthUrl = Uri(
    scheme: 'https',
    host: 'anilist.co',
    path: '/api/v2/oauth/authorize',
    queryParameters: {
      'client_id': dotenv.env['ANILIST_ID'],
      'response_type': 'token',
    },
  );

  String? accessToken;

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
  void onProtocolUrlReceived(String url) {
    final uri = Uri.parse(url.replaceFirst('#', '?'));

    /**
     * On `anikki://anilist-auth?blabla=hello`
     * 
     * final scheme = uri.scheme; // anikki
     * final host = uri.host; // anilist-auth
     * final query = uri.query; // blabla=hello
     * final params = uri.queryParameters; // {blabla: hello}
     */

    if (!availableHosts.contains(uri.host)) return;

    final token = uri.queryParameters['access_token'];

    if (token == null) return;

    setState(() {
      accessToken = token;
    });
  }

  Future<void> showConnectionDialog(
      BuildContext context, bool connected) async {
    await showDialog(
      context: context,
      builder: (context) {
        if (connected) {
          return AlertDialog(
            title: const Text('Connected to Anilist'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Connecting to Anilist'),
            content: const Text(
                'Please press Next once you have authorized Anikki on Anilsit'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Next'),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> login(BuildContext context) async {
    final authBloc = BlocProvider.of<AnilistAuthBloc>(context);

    launchUrl(oauthUrl, mode: LaunchMode.externalApplication);
    await showConnectionDialog(context, false);

    if (accessToken == null) return;

    authBloc.add(AnilistAuthLoginRequested(token: accessToken));

    if (mounted) await showConnectionDialog(context, true);
  }

  Future<void> logout(BuildContext context) async {
    BlocProvider.of<AnilistAuthBloc>(context).add(AnilistAuthLogoutRequested());
    setState(() {
      accessToken = null;
    });
  }
}
