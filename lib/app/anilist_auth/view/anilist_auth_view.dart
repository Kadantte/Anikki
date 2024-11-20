import 'package:anikki/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_icons/simple_icons.dart';

import 'package:anikki/app/anilist_auth/bloc/anilist_auth_bloc.dart';
import 'package:anikki/app/anilist_auth/shared/helpers/login.dart';

enum AnilistMenuItem {
  auth,
  logout,
}

class AnilistAuthView extends StatefulWidget {
  const AnilistAuthView({super.key});

  @override
  State<AnilistAuthView> createState() => _AnilistAuthViewState();
}

class _AnilistAuthViewState extends State<AnilistAuthView> {
  @override
  Widget build(BuildContext context) {
    final providerTitle = WatchListProvider.anilist.title;

    final connectButton = OutlinedButton.icon(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(16.0)),
        textStyle: WidgetStatePropertyAll(context.textTheme.bodyLarge),
      ),
      onPressed: () => loginToAnilist(context),
      label: Text('Connect with $providerTitle'),
      icon: const Icon(SimpleIcons.anilist),
    );

    return BlocBuilder<AnilistAuthBloc, AnilistAuthState>(
      builder: (context, state) => switch (state) {
        AnilistAuthLoggedOut() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You are not logged into $providerTitle.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              connectButton,
            ],
          ),
        AnilistAuthError() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Could not log you into $providerTitle',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              connectButton,
            ],
          ),
        _ => const SizedBox(),
      },
    );
  }
}
