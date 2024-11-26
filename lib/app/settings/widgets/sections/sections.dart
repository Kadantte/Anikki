import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yaml/yaml.dart';

import 'package:anikki/app/provider_auth/bloc/provider_auth_bloc.dart';
import 'package:anikki/app/provider_auth/shared/helpers/login.dart';
import 'package:anikki/app/provider_auth/shared/helpers/logout.dart';
import 'package:anikki/app/settings/bloc/settings_bloc.dart';
import 'package:anikki/app/settings/widgets/settings_text_field.dart';
import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/anikki_icon.dart';

part 'connections_section.dart';
part 'developper_section.dart';
part 'general_section.dart';
part 'streaming_section.dart';
part 'torrent_section.dart';
part 'video_player_section.dart';
