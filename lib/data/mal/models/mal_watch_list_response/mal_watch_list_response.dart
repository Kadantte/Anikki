import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'list_status.dart';
import 'node.dart';

class MalWatchListResponse extends Equatable {
  final Node? node;
  final ListStatus? listStatus;

  const MalWatchListResponse({this.node, this.listStatus});

  factory MalWatchListResponse.fromMap(Map<String, dynamic> data) {
    return MalWatchListResponse(
      node: data['node'] == null
          ? null
          : Node.fromMap(data['node'] as Map<String, dynamic>),
      listStatus: data['list_status'] == null
          ? null
          : ListStatus.fromMap(data['list_status'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'node': node?.toMap(),
        'list_status': listStatus?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MalWatchListResponse].
  factory MalWatchListResponse.fromJson(String data) {
    return MalWatchListResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MalWatchListResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [node, listStatus];
}
