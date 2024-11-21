import 'package:flutter/material.dart';

import 'package:anikki/app/provider_auth/shared/helpers/login.dart';
import 'package:anikki/core/core.dart';

class AnilistAuthView extends StatelessWidget {
  const AnilistAuthView({
    super.key,
    required this.provider,
  });

  final WatchListProvider provider;

  String get providerTitle => provider.title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'You are not logged into $providerTitle.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        FilledButton.tonalIcon(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(16.0)),
            textStyle: WidgetStatePropertyAll(context.textTheme.bodyLarge),
          ),
          onPressed: () => loginToProvider(provider, context),
          label: Text('Connect with $providerTitle'),
          icon: Icon(
            provider.icon,
            color: provider.color,
          ),
        ),
      ],
    );
  }
}
