part of 'provider_auth_bloc.dart';

class ProviderAuthState extends Equatable {
  const ProviderAuthState({
    this.anilistUser,
    this.malUser,
  });

  final Query$Viewer$Viewer? anilistUser;
  final MalUser? malUser;

  @override
  List<Object?> get props => [anilistUser, malUser];

  @override
  String toString() {
    return [
      'ProviderAuthState(',
      'AniList username: ${anilistUser?.name}',
      'MyAnimeList username: ${malUser?.name}',
      ')',
    ].join(', ');
  }

  ProviderAuthState copyWith({
    Query$Viewer$Viewer? anilistUser,
    MalUser? malUser,
  }) {
    return ProviderAuthState(
      anilistUser: anilistUser ?? this.anilistUser,
      malUser: malUser ?? this.malUser,
    );
  }
}
