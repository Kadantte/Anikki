import 'dart:convert';

import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  final String? job;
  final String? department;
  final String? creditId;
  final bool? adult;
  final int? gender;
  final int? id;
  final String? knownForDepartment;
  final String? name;
  final String? originalName;
  final double? popularity;
  final String? profilePath;

  const Crew({
    this.job,
    this.department,
    this.creditId,
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
  });

  factory Crew.fromMap(Map<String, dynamic> data) => Crew(
        job: data['job'] as String?,
        department: data['department'] as String?,
        creditId: data['credit_id'] as String?,
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
        'job': job,
        'department': department,
        'credit_id': creditId,
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
  /// Parses the string and returns the resulting Json object as [Crew].
  factory Crew.fromJson(String data) {
    return Crew.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Crew] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      job,
      department,
      creditId,
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
