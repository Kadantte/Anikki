class AnilistNotConnectedException implements Exception {
  final String? cause;

  const AnilistNotConnectedException([this.cause]);

  @override
  String toString() => 'AnilistNotConnectedException(cause: $cause)';
}
