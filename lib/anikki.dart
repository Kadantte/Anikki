import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protocol_handler/protocol_handler.dart';

import 'package:anikki/config/config.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/app/provider_auth/shared/mixins/provider_auth_mixin.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/app/layouts/view/layout_page.dart';

class Anikki extends StatefulWidget {
  const Anikki({
    super.key,
  });

  @override
  State<Anikki> createState() => _AnikkiState();
}

class _AnikkiState extends State<Anikki>
    with ProtocolListener, ProviderAuthMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anikki',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: BlocProvider.of<SettingsBloc>(context, listen: true)
          .state
          .settings
          .theme,
      home: Scaffold(
        body: SafeArea(
          /// This BlocBuilder is necessary to instanciate the [ConnectivityBloc]
          /// Otherwise it is instanciated on the first use.
          child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, _) {
              return const BlocListeners(
                child: LayoutPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
