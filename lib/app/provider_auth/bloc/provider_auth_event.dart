part of 'provider_auth_bloc.dart';

sealed class ProviderAuthEvent extends Equatable {
  const ProviderAuthEvent();
}

final class ProviderAuthLogoutRequested extends ProviderAuthEvent {
  const ProviderAuthLogoutRequested(this.provider);

  final WatchListProvider provider;

  @override
  List<Object> get props => [
        provider,
      ];

  @override
  bool? get stringify => true;
}

final class ProviderAuthLoginRequested extends ProviderAuthEvent {
  const ProviderAuthLoginRequested(this.provider);

  final WatchListProvider provider;

  @override
  List<Object> get props => [
        provider,
      ];

  @override
  bool? get stringify => true;
}

final class ProviderAuthInitialLoginRequested extends ProviderAuthEvent {
  const ProviderAuthInitialLoginRequested();

  @override
  List<Object?> get props => [];
}
