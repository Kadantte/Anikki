part of 'sections.dart';

class ConnectionsSection extends AbstractSettingsSection {
  const ConnectionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: const Text('Connections'),
      tiles: [
        /// Stream request type
        SettingsTile(
          title: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.spaceAround,
            children: [
              for (final provider in WatchListProvider.values)
                BlocBuilder<ProviderAuthBloc, ProviderAuthState>(
                  builder: (context, state) {
                    final connected = switch (provider) {
                      WatchListProvider.anilist => state.anilistUser != null,
                      WatchListProvider.mal => state.malUser != null,
                      WatchListProvider.kitsu => false,
                    };

                    final username = switch (provider) {
                      WatchListProvider.anilist => state.anilistUser?.name,
                      WatchListProvider.mal => state.malUser?.name,
                      WatchListProvider.kitsu => null,
                    };

                    return Column(
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            return connected
                                ? logoutFromProvider(provider, context)
                                : loginToProvider(provider, context);
                          },
                          label: Text(provider.title),
                          icon: Icon(
                            provider.icon,
                            color: provider.color,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        if (username != null)
                          Text(
                            'Connected as $username',
                            style: context.textTheme.bodySmall,
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
