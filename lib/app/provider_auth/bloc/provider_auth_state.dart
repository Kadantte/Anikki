part of 'provider_auth_bloc.dart';

class ProviderAuthState extends Equatable {
  const ProviderAuthState({
    this.anilistUser,
  });

  final Query$Viewer$Viewer? anilistUser;

  @override
  List<Object?> get props => [
        anilistUser,
      ];

  @override
  String toString() {
    return [
      'ProviderAuthState(',
      'AniList username: ${anilistUser?.name}',
      ')',
    ].join(', ');
  }
}

final class ProviderAuthError extends ProviderAuthState {
  const ProviderAuthError({
    required this.message,
    super.anilistUser,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
        anilistUser,
      ];
}
