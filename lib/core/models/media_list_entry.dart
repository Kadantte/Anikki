import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

class MediaListEntry extends Equatable {
  const MediaListEntry({
    required this.media,
    required this.progress,
    this.updatedAt,
    this.score,
    this.status,
    this.notes,
  });

  final Media media;
  final int? progress;
  final int? updatedAt;
  final double? score;
  final Enum$MediaListStatus? status;
  final String? notes;

  factory MediaListEntry.fromAnilistListEntry(
    AnilistListEntry listEntry, [
    Media? media,
  ]) {
    return MediaListEntry(
      media: media ?? Media(anilistInfo: listEntry.media),
      progress: listEntry.progress,
      updatedAt: listEntry.updatedAt,
      score: listEntry.score,
      status: listEntry.status,
      notes: listEntry.notes,
    );
  }

  MediaListEntry copyWith({
    Media? media,
    int? progress,
    int? updatedAt,
    double? score,
    Enum$MediaListStatus? status,
    String? notes,
  }) {
    return MediaListEntry(
      media: media ?? this.media,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      score: score ?? this.score,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'media': media.toMap(),
      'progress': progress,
      'updatedAt': updatedAt,
      'score': score,
      'status': status?.toJson(),
      'notes': notes,
    };
  }

  factory MediaListEntry.fromMap(Map<String, dynamic> map) {
    return MediaListEntry(
      media: Media.fromMap(map['media'] as Map<String, dynamic>),
      progress: map['progress'] != null ? map['progress'] as int : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as int : null,
      score: map['score'] != null ? map['score'] as double : null,
      status: map['status'] != null
          ? Enum$MediaListStatus.fromJson(map['status'] as String)
          : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaListEntry.fromJson(String source) =>
      MediaListEntry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      media,
      progress,
      updatedAt,
      score,
      status,
      notes,
    ];
  }
}
