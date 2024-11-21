part of 'provider_auth_bloc.dart';

sealed class ProviderAuthEvent extends Equatable {
  const ProviderAuthEvent(this.provider);

  final WatchListProvider provider;

  @override
  List<Object> get props => [
        provider,
      ];

  @override
  bool? get stringify => true;
}

final class ProviderAuthLogoutRequested extends ProviderAuthEvent {
  const ProviderAuthLogoutRequested(super.provider);
}

final class ProviderAuthLoginRequested extends ProviderAuthEvent {
  const ProviderAuthLoginRequested(super.provider);
}
