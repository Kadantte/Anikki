import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:anikki/app/layouts/widgets/portrait/anikki_navigation_bar.dart';
import 'package:anikki/app/library/library.dart';
import 'package:anikki/app/library/widgets/library_card.dart';
import 'package:anikki/core/helpers/desktop_hooks.dart';
import 'package:anikki/core/widgets/anikki_action_button.dart';
import 'package:anikki/core/widgets/grid_view/custom_grid_view.dart';
import 'package:anikki/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration: Library', () {
    testWidgets('can select a folder', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      if (isDesktop()) {
        /// Opening Library dialog
        final menuButton = find.byTooltip('Library');

        await tester.tap(menuButton);
        await tester.pumpAndSettle();

        /// Checking for existence of [LibraryPage].
        final library = find.byType(LibraryView);
        expect(library, findsOneWidget);

        /// Checking [UserListAppBar]
        final userListAppBar = find.byType(AppBar);
        expect(userListAppBar, findsOneWidget);

        /// Finding the Settings button and clicking on it
        final settingsButton = find.descendant(
            of: userListAppBar, matching: find.byType(AnikkiActionButton));
        expect(settingsButton, findsOneWidget);

        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        /// Finds the `Change Folder` button
        final changeFolderButton = find.text('Change folder');
        expect(changeFolderButton, findsOneWidget);
      } else {
        /// Finds main navigation bar
        final navBar = find.byType(AnikkiNavigationBar);
        expect(navBar, findsOneWidget);

        /// Finds library view button
        final libraryButton = find.byIcon(Icons.library_books_outlined);
        expect(libraryButton, findsOneWidget);

        await tester.tap(libraryButton);
        await tester.pumpAndSettle();

        /// Checking for existence of [LibraryPage].
        final library = find.byType(LibraryView);
        expect(library, findsOneWidget);

        /// Finds Change folder button
        final folderButton = find.byIcon(Icons.folder_open_outlined);
        expect(folderButton, findsOneWidget);
      }
    });

    testWidgets('layout toggle changes the layout', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      final layout = find.byType(CustomGridView);
      expect(layout, findsOneWidget);

      /// Layout should be grid at first
      expect(
        find.descendant(
          of: layout,
          matching: find.byType(LibraryCard),
        ),
        findsWidgets,
      );
    });
  });
}
