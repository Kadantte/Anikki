import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:anikki/app/layouts/bloc/layout_bloc.dart';
import 'package:anikki/app/settings/widgets/sections/sections.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/section/section_title.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        final portrait = state is LayoutPortrait;

        return Column(
          children: [
            if (!portrait) ...const [
              Row(
                children: [
                  SectionTitle(
                    text: 'Settings',
                  ),
                ],
              ),
              Divider(
                height: 1,
              ),
            ],
            Expanded(
              child: SettingsList(
                darkTheme: SettingsThemeData(
                  settingsListBackground: context.colorScheme.surface,
                  settingsSectionBackground:
                      context.colorScheme.surfaceContainerHighest,
                ),
                lightTheme: SettingsThemeData(
                  settingsListBackground: context.colorScheme.surface,
                  settingsSectionBackground:
                      context.colorScheme.surfaceContainerHighest,
                ),
                sections: [
                  const GeneralSection(),
                  const ConnectionsSection(),
                  const VideoPlayerSection(),
                  const StreamingSection(),
                  const TorrentSection(),
                  const DevelopperSection(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
