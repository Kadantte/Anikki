part of 'repository.dart';

Future<void> updateFolderPath(BuildContext context) async {
  final settingsBloc = BlocProvider.of<SettingsBloc>(context);
  final libraryBloc = BlocProvider.of<LibraryBloc>(context);

  String? path = await getDirectoryPath();

  if (path == null) return;

  settingsBloc.add(
    SettingsUpdated(
      settingsBloc.state.settings.copyWith(
        localDirectory: path,
      ),
    ),
  );

  libraryBloc.add(LibraryUpdateRequested(path: path));
}