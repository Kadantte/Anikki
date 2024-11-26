part of 'anilist.dart';

mixin AnilistAuth on AnilistClient {
  @override
  Future<Query$Viewer$Viewer> getMe() async {
    final result = await client.query$Viewer(Options$Query$Viewer());

    if (result.hasException || result.parsedData?.Viewer == null) {
      final linkException = result.exception?.linkException;
      final isHttpException = linkException is HttpLinkServerException;

      if (isHttpException) {
        throw AnilistNotConnectedException(
          linkException.parsedResponse?.errors.toString(),
        );
      }
      throw AnilistNotConnectedException(
        result.exception?.linkException.toString(),
      );
    }

    return result.parsedData!.Viewer!;
  }
}
