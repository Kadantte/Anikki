class MalUpdateListException implements Exception {
  String? error;
  int? mediaId;

  String get cause =>
      'Could not update user list entry with ID $mediaId on MyAnimeList';

  MalUpdateListException({
    this.error,
    this.mediaId,
  });
}
