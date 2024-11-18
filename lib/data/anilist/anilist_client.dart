part of 'anilist.dart';

abstract class AnilistClient {
  final GraphQLClient client;

  AnilistClient({required this.client});

  Future<Query$Viewer$Viewer> getMe();
}
