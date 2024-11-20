import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import 'package:anikki/core/models/watch_list_provider.dart';
import 'package:anikki/domain/user_repository.dart';

class MalClient extends BaseClient {
  MalClient();

  final Client client = Client();

  static const baseUrl = 'https://api.myanimelist.net/v2';

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final box = await Hive.openBox(UserRepository.boxName);
    final String? token = box.get(
      UserRepository.tokenKey[WatchListProvider.mal],
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return client.send(request);
  }
}
