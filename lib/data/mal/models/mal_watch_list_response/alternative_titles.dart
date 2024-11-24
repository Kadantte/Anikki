import 'dart:convert';

import 'package:equatable/equatable.dart';

class AlternativeTitles extends Equatable {
  final List<String>? synonyms;
  final String? en;
  final String? ja;

  const AlternativeTitles({this.synonyms, this.en, this.ja});

  factory AlternativeTitles.fromMap(Map<String, dynamic> data) {
    return AlternativeTitles(
      synonyms:
          data['synonyms'] == null ? null : List<String>.from(data['synonyms']),
      en: data['en'] as String?,
      ja: data['ja'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'synonyms': synonyms,
        'en': en,
        'ja': ja,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AlternativeTitles].
  factory AlternativeTitles.fromJson(String data) {
    return AlternativeTitles.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AlternativeTitles] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [synonyms, en, ja];
}
