import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/domain/user_repository.dart';

/// Handles Authentication and request to MAL Api
/// Authentication documentation: https://myanimelist.net/apiconfig/references/authorization
class MalClient extends BaseClient {
  MalClient();

  final Client client = Client();

  static const baseUrl = 'https://api.myanimelist.net/v2';

  final WatchListProvider provider = WatchListProvider.mal;
  String get providerTitle => provider.title;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    logger.info(
      'Sending request to ${provider.title}',
      request,
    );

    final box = await Hive.openBox(UserRepository.boxName);
    final String? jsonToken = box.get(
      UserRepository.tokenKey[WatchListProvider.mal],
    );

    if (jsonToken == null) {
      throw Exception('No token for ${WatchListProvider.mal.title}');
    }

    final parsedToken = jsonDecode(jsonToken);

    final String tokenType = parsedToken['token_type'];
    final int expiresIn = parsedToken['expires_in'];
    String accessToken = parsedToken['access_token'];
    final String refreshToken = parsedToken['refresh_token'];
    final int issuedAt = parsedToken['issued_at'];
    final int expiresAt = issuedAt + expiresIn;

    final now = DateTime.now().millisecondsSinceEpoch;

    if (expiresAt < now + (1000 * 10)) {
      accessToken = await refreshAccessToken(refreshToken);
    }

    request.headers['Authorization'] = '$tokenType $accessToken';

    return client.send(request);
  }

  Future<String> refreshAccessToken(String refreshToken) async {
    logger.info('Refreshing $providerTitle credentials...');
    final appId = dotenv.env['MAL_ID'];

    final response = await post(
      Uri(
        host: 'myanimelist.net',
        path: 'v1/oauth2/token',
        scheme: 'https',
      ),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': appId,
        'client_secret': '',
        'refresh_token': refreshToken,
        'grant_type': "refresh_token",
      },
    );

    final parsedBody = jsonDecode(response.body);
    parsedBody['issued_at'] = DateTime.now().millisecondsSinceEpoch;

    final provider = WatchListProvider.mal;
    final boxKey = UserRepository.tokenKey[provider];
    final box = await Hive.openBox(UserRepository.boxName);
    await box.put(boxKey, jsonEncode(parsedBody));

    logger.info('Successfully refreshed $providerTitle credentials!');

    return parsedBody['access_token'];
  }
}
