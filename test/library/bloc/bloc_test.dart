import 'dart:io';

import 'package:anikki/features/settings/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:anikki/features/library/bloc/library_bloc.dart';
import 'package:anikki/features/library/repository/repository.dart';
import 'package:anikki/features/settings/bloc/settings_bloc.dart';
import 'package:anikki/models/library_entry.dart';
import 'package:anikki/models/local_file.dart';

import '../../helpers/init_hive.dart';
import '../../helpers/init_hydrated_storage.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockLocalFile extends Mock implements LocalFile {}

void main() {
  initHive();
  initHydratedStorage();

  /// Shuts off logging except for errors
  Logger.level = Level.error;

  const path = 'test/resources/movies';
  const emptyPath = '$path/empty';
  const noPath = 'no/path';
  const toAddPath =
      '$path/[SubsPlease] Kaminaki Sekai no Kamisama Katsudou - 04 (1080p) [0328F445].mkv';
  final files = [
    LocalFile(
        path:
            '$path/[SubsPlease] Kimi wa Houkago Insomnia - 02 (1080p) [BC586D6A].mkv'),
    LocalFile(
        path:
            '$path/[SubsPlease] Kimi wa Houkago Insomnia - 03 (1080p) [BC586D6A].mkv'),
    LocalFile(
        path:
            '$path/[SubsPlease] Kaminaki Sekai no Kamisama Katsudou - 03 (1080p) [0328F445].mkv'),
    LocalFile(
        path:
            '$path/[SubsPlease] Kuma Kuma Kuma Bear S2 - 04 (1080p) [67E8004E].mkv'),
    LocalFile(
        path:
            '$path/nested/[SubsPlease] NieR Automata Ver1 - 02 (1080p) [CC00E892].mkv'),
  ];

  const settings = Settings(
    localDirectory: path,
    newsLayout: NewsLayouts.list,
    userListLayouts: UserListLayouts.grid,
    theme: ThemeMode.system,
  );

  group('unit test: Library Bloc', () {
    late LibraryBloc bloc;
    late LibraryRepository repository;
    late SettingsBloc settingsBloc;

    late LocalFile mockFile;

    setUp(() {
      /// File mock
      mockFile = MockLocalFile();
      when(() => mockFile.path).thenReturn(toAddPath);
      when(() => mockFile.file).thenReturn(File(toAddPath));
      when(() => mockFile.title)
          .thenReturn('Kaminaki Sekai no Kamisama Katsudou');
      when(() => mockFile.episode).thenReturn(4);

      /// Repository mock
      repository = MockLibraryRepository();
      when(() => repository.getFile(toAddPath))
          .thenAnswer((_) async => mockFile);
      when(() => repository.retrieveFilesFromPath(emptyPath)).thenAnswer(
        (_) async => [],
      );
      when(() => repository.retrieveFilesFromPath(path)).thenAnswer(
        (_) async => files,
      );

      /// Settings Bloc mock
      settingsBloc = MockSettingsBloc();
      when(() => settingsBloc.stream).thenAnswer(
        (_) => const Stream<SettingsState>.empty(),
      );
      when(() => settingsBloc.state).thenAnswer(
        (_) => const SettingsState(
          settings: settings,
        ),
      );

      /// Instanciating bloc mock
      bloc = LibraryBloc(
        settingsBloc: settingsBloc,
        repository: repository,
      );
    });

    group('Event: [LibraryUpdateRequested]', () {
      blocTest(
        'emits nothing when [LibraryUpdateRequested] is added with `null` path',
        build: () => bloc,
        act: (bloc) => bloc.add(const LibraryUpdateRequested(path: null)),
        expect: () => [],
        verify: (bloc) {
          verifyNever(() => repository.retrieveFilesFromPath(path));
        },
      );

      blocTest(
        'emits [LibraryLoading, LibraryLoaded] when [LibraryUpdateRequested] is added',
        build: () => bloc,
        act: (bloc) => bloc.add(const LibraryUpdateRequested(path: path)),
        expect: () => [
          const LibraryLoading(path: path),
          isA<LibraryLoaded>()
              .having(
            (p0) => p0.entries.length,
            'with the right number of entries',
            4,
          )
              .having(
            (p0) => p0.expandedEntries,
            'with the right expanded list',
            [true, false, true, true],
          ),
        ],
        verify: (bloc) {
          verify(() => repository.retrieveFilesFromPath(path)).called(1);
          expect(bloc.subscription, isNotNull);
        },
      );

      blocTest(
        'emits [LibraryLoading, LibraryEmpty] when [LibraryUpdateRequested] is added on empty directory',
        build: () => bloc,
        act: (bloc) => bloc.add(const LibraryUpdateRequested(path: emptyPath)),
        expect: () => [
          const LibraryLoading(path: emptyPath),
          const LibraryEmpty(path: emptyPath),
        ],
        verify: (bloc) {
          verify(() => repository.retrieveFilesFromPath(emptyPath)).called(1);
          expect(bloc.subscription, isNotNull);
        },
      );

      blocTest(
        'emits [LibraryLoading, LibraryError] when [LibraryUpdateRequested] is added on non-existing directory',
        build: () => bloc,
        act: (bloc) => bloc.add(const LibraryUpdateRequested(path: noPath)),
        expect: () => [
          const LibraryLoading(path: noPath),
          isA<LibraryError>().having((p0) => p0.path, 'the right path', noPath),
        ],
        verify: (bloc) {
          verify(() => repository.retrieveFilesFromPath(noPath)).called(1);
          expect(bloc.subscription, isNull);
        },
      );
    });

    group('Event: [LibraryFileAdded]', () {
      blocTest<LibraryBloc, LibraryState>(
        'emit [LibraryLoaded] when [LibraryFileAdded] is added when no entry in [Library]',
        build: () => bloc,
        seed: () => const LibraryLoaded(
          id: 0,
          path: path,
          entries: [],
          expandedEntries: [],
        ),
        act: (bloc) => bloc.add(const LibraryFileAdded(path: toAddPath)),
        expect: () => [
          isA<LibraryLoaded>()
              .having(
                (p0) => p0.entries.length,
                'Has one entry',
                equals(1),
              )
              .having(
                (p0) => p0.entries.first.entries.first,
                'with the right file',
                equals(mockFile),
              )
              .having(
            (p0) => p0.expandedEntries,
            'Has expanded entries list',
            [true],
          ),
        ],
        verify: (bloc) {
          verify(
            () => repository.getFile(toAddPath),
          ).called(1);
        },
      );

      blocTest<LibraryBloc, LibraryState>(
        'emit [LibraryLoaded] when [LibraryFileAdded] is added when there are entries in [Library] but no entry with same name',
        build: () => bloc,
        seed: () => LibraryLoaded(
          id: 0,
          path: path,
          entries: [
            LibraryEntry(
              media: null,
              entries: [
                LocalFile(path: '$path/[SubsPlease] No name - 02.mkv'),
              ],
            )
          ],
          expandedEntries: const [true],
        ),
        act: (bloc) => bloc.add(const LibraryFileAdded(path: toAddPath)),
        expect: () => [
          isA<LibraryLoaded>()
              .having(
                (p0) => p0.entries.length,
                'has two entries',
                equals(2),
              )
              .having(
                (p0) => p0.entries.firstWhere(
                    (element) => element.entries.contains(mockFile)),
                'with the new file',
                isNotNull,
              )
              .having(
            (p0) => p0.expandedEntries,
            'with right expanded entries list',
            [true, true],
          ),
        ],
        verify: (bloc) {
          verify(
            () => repository.getFile(toAddPath),
          ).called(1);
        },
      );

      blocTest<LibraryBloc, LibraryState>(
        'emit [LibraryLoaded] when [LibraryFileAdded] is added when there are entries in [Library] and some with same name',
        build: () => bloc,
        seed: () => LibraryLoaded(
          id: 0,
          path: path,
          entries: [
            LibraryEntry(
              media: null,
              entries: [
                LocalFile(path: '$path/[SubsPlease] No name - 02.mkv'),
              ],
            ),
            LibraryEntry(
              media: null,
              entries: [
                LocalFile(
                    path:
                        '$path/[SubsPlease] Kaminaki Sekai no Kamisama Katsudou - 03 (1080p) [0328F445].mkv'),
              ],
            )
          ],
          expandedEntries: const [true, true],
        ),
        act: (bloc) => bloc.add(const LibraryFileAdded(path: toAddPath)),
        expect: () => [
          isA<LibraryLoaded>()
              .having(
                (p0) => p0.entries.length,
                'has two entries',
                equals(2),
              )
              .having(
                (p0) => p0.entries.firstWhere(
                    (element) => element.entries.contains(mockFile)),
                'with the new file',
                isNotNull,
              )
              .having(
                (p0) => p0.entries
                    .firstWhere((element) => element.entries.contains(mockFile))
                    .entries
                    .length,
                'grouped with the same name',
                equals(2),
              )
              .having(
                (p0) => p0.entries
                    .firstWhere((element) => element.entries.contains(mockFile))
                    .entries
                    .first,
                'entries in the the right order',
                equals(mockFile),
              )
              .having(
            (p0) => p0.expandedEntries,
            'with right expanded entries list',
            [true, false],
          ),
        ],
        verify: (bloc) {
          verify(
            () => repository.getFile(toAddPath),
          ).called(1);
        },
      );
    });
  });
}
