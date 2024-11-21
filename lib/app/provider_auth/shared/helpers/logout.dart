import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anikki/app/provider_auth/bloc/provider_auth_bloc.dart';
import 'package:anikki/core/core.dart';

void logoutFromAnilist(BuildContext context) {
  BlocProvider.of<ProviderAuthBloc>(context).add(
    ProviderAuthLogoutRequested(WatchListProvider.anilist),
  );
}
