import 'dart:convert';

import 'package:equatable/equatable.dart';

class Broadcast extends Equatable {
  final String? dayOfTheWeek;
  final String? startTime;

  const Broadcast({this.dayOfTheWeek, this.startTime});

  factory Broadcast.fromMap(Map<String, dynamic> data) => Broadcast(
        dayOfTheWeek: data['day_of_the_week'] as String?,
        startTime: data['start_time'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'day_of_the_week': dayOfTheWeek,
        'start_time': startTime,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Broadcast].
  factory Broadcast.fromJson(String data) {
    return Broadcast.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Broadcast] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [dayOfTheWeek, startTime];
}
