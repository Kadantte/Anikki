import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

import 'package:anikki/features/library/domain/domain.dart';
import 'package:anikki/features/library/presentation/helpers/to_library_entry.dart';
import 'package:anikki/core/models/library_entry.dart';
import 'package:anikki/features/settings/bloc/settings_bloc.dart';
import 'package:anikki/core/helpers/logger.dart';
import 'package:anikki/core/models/local_file.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final SettingsBloc settingsBloc;

  DirectoryWatcher? watcher;
  StreamSubscription<WatchEvent>? subscription;

  final LibraryRepository repository;

  LibraryBloc({
    required this.settingsBloc,
    this.repository = const LibraryRepository(),
  }) : super(const LibraryInitial()) {
    on<LibraryEvent>((event, emit) {
      logger.v('Library event: ${event.runtimeType}');
    });

    on<LibraryUpdateRequested>(_onUpdateRequested);
    on<LibraryFileDeleted>(_onFileDeleted);
    on<LibraryFileAdded>(_onFileAdded);
    on<LibraryFileDeleteRequested>(__onFileDeleteRequested);
    on<LibraryFilePlayRequested>(__onFilePlayRequested);

    settingsBloc.stream.listen((settingsState) {
      final newPath = settingsState.settings.localDirectory;
      final currentPath = state.path;

      if (newPath != currentPath) {
        add(LibraryUpdateRequested(path: newPath));
      }
    });
  }

  void _setupWatcher(String path) {
    subscription?.cancel();

    watcher = DirectoryWatcher(path);
    subscription = watcher?.events.listen((event) {
      switch (event.type) {
        case ChangeType.ADD:
          if (['.mkv', '.mp4'].contains(extension(event.path))) {
            add(
              LibraryFileAdded(path: event.path),
            );
          }
          break;

        case ChangeType.REMOVE:
          add(
            LibraryFileDeleted(
              file: LocalFile(
                path: event.path,
              ),
            ),
          );
          break;

        case ChangeType.MODIFY:
        default:
          break;
      }
    });
  }

  Future<void> _onUpdateRequested(
      LibraryUpdateRequested event, Emitter<LibraryState> emit) async {
    final path = event.path ??

        /// Cannot mock `getDirecotryPath` method...
        (Platform.environment.containsKey('FLUTTER_TEST')
            ? null
            : await FilePicker.platform.getDirectoryPath());

    if (path == null) return;

    emit(LibraryLoading(path: path));

    try {
      final files = await repository.retrieveFilesFromPath(path);

      if (files.isEmpty) {
        emit(LibraryEmpty(path: path));
      } else {
        final entries = toLibraryEntry(files);

        sortEntries(entries);

        emit(
          LibraryLoaded(
            entries: entries,
            path: path,
          ),
        );
      }

      settingsBloc.add(
        SettingsUpdated(
          settingsBloc.state.settings.copyWith(
            localDirectory: path,
          ),
        ),
      );

      _setupWatcher(path);
    } catch (e) {
      emit(
        LibraryError(
          message: e.toString(),
          path: path,
        ),
      );
    }
  }

  void _onFileDeleted(LibraryFileDeleted event, Emitter<LibraryState> emit) {
    if (state.runtimeType != LibraryLoaded) return;

    final file = event.file;

    /// Find `file` in existing entries if any
    final currentState = state as LibraryLoaded;

    final entries = List<LibraryEntry>.from(currentState.entries);

    removeFile(entries, file);

    if (entries.isEmpty) {
      emit(LibraryEmpty(path: state.path));
    } else {
      emit(
        LibraryLoaded(
          id: currentState.id + 1,
          entries: entries,
          path: state.path,
        ),
      );
    }
  }

  Future<void> _onFileAdded(
      LibraryFileAdded event, Emitter<LibraryState> emit) async {
    if (state.runtimeType != LibraryLoaded) return;

    final file = await repository.getFile(event.path);

    /// Find `file` in existing entries if any
    final currentState = state as LibraryLoaded;

    List<LibraryEntry> entries = List<LibraryEntry>.from(currentState.entries);

    addFile(entries, file);

    emit(
      LibraryLoaded(
        id: currentState.id + 1,
        entries: entries,
        path: state.path,
      ),
    );
  }

  Future<void> __onFileDeleteRequested(
      LibraryFileDeleteRequested event, Emitter<LibraryState> emit) async {
    await deleteFile(event.file, event.context);
  }

  Future<void> __onFilePlayRequested(
      LibraryFilePlayRequested event, Emitter<LibraryState> emit) async {
    await playFile(event.file, event.context);
  }
}