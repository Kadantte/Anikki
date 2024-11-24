import 'dart:convert';

import 'package:equatable/equatable.dart';

class MainPicture extends Equatable {
  final String? medium;
  final String? large;

  const MainPicture({this.medium, this.large});

  factory MainPicture.fromMap(Map<String, dynamic> data) => MainPicture(
        medium: data['medium'] as String?,
        large: data['large'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'medium': medium,
        'large': large,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MainPicture].
  factory MainPicture.fromJson(String data) {
    return MainPicture.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MainPicture] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [medium, large];
}
