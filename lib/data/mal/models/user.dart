import 'dart:convert';

import 'package:equatable/equatable.dart';

class MalUser extends Equatable {
  const MalUser({
    required this.id,
    required this.name,
    required this.picture,
  });

  final int id;
  final String name;
  final String? picture;

  MalUser copyWith({
    int? id,
    String? name,
    String? picture,
  }) {
    return MalUser(
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picture': picture,
    };
  }

  factory MalUser.fromMap(Map<String, dynamic> map) {
    return MalUser(
      id: map['id'] as int,
      name: map['name'] as String,
      picture: map['picture'] != null ? map['picture'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MalUser.fromJson(String source) =>
      MalUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, picture];
}
