import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/provider_auth/bloc/provider_auth_bloc.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/layout_card.dart';

Future<void> logoutFromProvider(
  WatchListProvider provider,
  BuildContext context,
) async {
  if (isDesktop()) {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: DisconnectFromProviderPrompt(
            provider: provider,
          ),
        );
      },
    );
  } else {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) => DisconnectFromProviderPrompt(
            provider: provider,
          ),
        );
      },
    );
  }
}

class DisconnectFromProviderPrompt extends StatelessWidget {
  const DisconnectFromProviderPrompt({
    super.key,
    required this.provider,
  });

  final WatchListProvider provider;

  void Function(BuildContext) get callback => switch (provider) {
        WatchListProvider.anilist => _logoutFromAnilist,
        WatchListProvider.mal => _logoutFromMal,
        WatchListProvider.kitsu => _logoutFromKitsu,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 500,
      child: LayoutCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
              title: Text(
                'Do you really want to disconnected from ${provider.title} ?',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                'All data related to ${provider.title} will be deleted from this device.\n You will still be able to reconnect to it whenever you want.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8.0),
                  FilledButton(
                    onPressed: () => callback(context),
                    child: const Text('Yes, I\'m sure!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _logoutFromAnilist(BuildContext context) {
  BlocProvider.of<ProviderAuthBloc>(context).add(
    ProviderAuthLogoutRequested(WatchListProvider.anilist),
  );
}

void _logoutFromMal(BuildContext context) {
  BlocProvider.of<ProviderAuthBloc>(context).add(
    ProviderAuthLogoutRequested(WatchListProvider.anilist),
  );
}

void _logoutFromKitsu(BuildContext context) {
  BlocProvider.of<ProviderAuthBloc>(context).add(
    ProviderAuthLogoutRequested(WatchListProvider.anilist),
  );
}
