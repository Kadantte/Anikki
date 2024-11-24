import 'dart:convert';

import 'package:equatable/equatable.dart';

class Studio extends Equatable {
  final int? id;
  final String? name;

  const Studio({this.id, this.name});

  factory Studio.fromMap(Map<String, dynamic> data) => Studio(
        id: data['id'] as int?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Studio].
  factory Studio.fromJson(String data) {
    return Studio.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Studio] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
