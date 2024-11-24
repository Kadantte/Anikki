import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

typedef AnilistUser = Query$Viewer$Viewer;

class UserRepository {
  const UserRepository({
    required this.anilist,
    required this.mal,
  });

  /// The [Anilist] API to use for this repository
  final Anilist anilist;

  /// The [Mal] API to use for this repository
  final Mal mal;

  /// The key used to store the auth token given from the provider
  static const tokenKey = {
    WatchListProvider.anilist: 'user_preferences_anilistAccessToken',
    WatchListProvider.mal: 'user_preferences_malAccessToken',
    WatchListProvider.kitsu: 'user_preferences_kitsuAccessToken',
  };

  /// The box name to use to store informations
  static const boxName = 'provider_auth';

  /// Returns the current user if any
  Future<AnilistUser?> getAnilistCurrentUser() async {
    try {
      return await anilist.getMe();
    } on AnilistNotConnectedException catch (e) {
      logger.warning(
          'Could not find currently authenticated user on AniList', e);
      return null;
    } catch (e) {
      logger.warning(
          'Could not find currently authenticated user on AniList', e);
      return null;
    }
  }

  /// Returns the current user if any
  Future<MalUser?> getMalCurrentUser() async {
    try {
      return await mal.getMe();
    } on MalGetUserException catch (e) {
      logger.warning('Could not find currently authenticated user on MAL', e);
      return null;
    } catch (e) {
      logger.warning('Could not find currently authenticated user on MAL', e);
      return null;
    }
  }
}
