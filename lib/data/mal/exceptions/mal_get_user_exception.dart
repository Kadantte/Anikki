class MalGetUserException implements Exception {
  final String cause = 'Could not retrieve user information from MyAnimeList';
  String? error;

  MalGetUserException({this.error});
}
