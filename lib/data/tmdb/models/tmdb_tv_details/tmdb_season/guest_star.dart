import 'dart:convert';

import 'package:equatable/equatable.dart';

class GuestStar extends Equatable {
  final String? character;
  final String? creditId;
  final int? order;
  final bool? adult;
  final int? gender;
  final int? id;
  final String? knownForDepartment;
  final String? name;
  final String? originalName;
  final double? popularity;
  final String? profilePath;

  const GuestStar({
    this.character,
    this.creditId,
    this.order,
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
  });

  factory GuestStar.fromMap(Map<String, dynamic> data) => GuestStar(
        character: data['character'] as String?,
        creditId: data['credit_id'] as String?,
        order: data['order'] as int?,
        adult: data['adult'] as bool?,
        gender: data['gender'] as int?,
        id: data['id'] as int?,
        knownForDepartment: data['known_for_department'] as String?,
        name: data['name'] as String?,
        originalName: data['original_name'] as String?,
        popularity: (data['popularity'] as num?)?.toDouble(),
        profilePath: data['profile_path'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'character': character,
        'credit_id': creditId,
        'order': order,
        'adult': adult,
        'gender': gender,
        'id': id,
        'known_for_department': knownForDepartment,
        'name': name,
        'original_name': originalName,
        'popularity': popularity,
        'profile_path': profilePath,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GuestStar].
  factory GuestStar.fromJson(String data) {
    return GuestStar.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GuestStar] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      character,
      creditId,
      order,
      adult,
      gender,
      id,
      knownForDepartment,
      name,
      originalName,
      popularity,
      profilePath,
    ];
  }
}
