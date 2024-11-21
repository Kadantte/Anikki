import 'package:anikki/core/core.dart';
import 'package:anikki/data/data.dart';

typedef AnilistUser = Query$Viewer$Viewer;

class UserRepository {
  const UserRepository(this.anilist);

  /// The [Anilist] API to use for this repository
  final Anilist anilist;

  /// The key used to store the auth token given from the provider
  static const tokenKey = {
    WatchListProvider.anilist: 'user_preferences_anilistAccessToken',
    WatchListProvider.mal: 'user_preferences_malAccessToken',
    WatchListProvider.kitsu: 'user_preferences_kitsuAccessToken',
  };

  /// The box name to use to store informations
  static const boxName = 'provider_auth';

  /// Returns the current user if any
  Future<AnilistUser> getAnilistCurrentUser() async {
    return await anilist.getMe();
  }
}
