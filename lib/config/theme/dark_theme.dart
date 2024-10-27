part of 'theme.dart';

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff748bac),
  onPrimary: Color(0xfff8f9fc),
  primaryContainer: Color(0xff1b2e4b),
  onPrimaryContainer: Color(0xffe4e7eb),
  secondary: Color(0xff539eaf),
  onSecondary: Color(0xfff5fbfc),
  secondaryContainer: Color(0xff004e5d),
  onSecondaryContainer: Color(0xffdfecee),
  tertiary: Color(0xff219ab5),
  onTertiary: Color(0xfff1fbfd),
  tertiaryContainer: Color(0xff0f5b6a),
  onTertiaryContainer: Color(0xffe2eef0),
  error: Color(0xffcf6679),
  onError: Color(0xff140c0d),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfffbe8ec),
  surface: Color(0xff161718),
  onSurface: Color(0xffececec),
  surfaceContainerHighest: Color(0xff383b3e),
  onSurfaceVariant: Color(0xffdfe0e0),
  outline: Color(0xff797979),
  outlineVariant: Color(0xff2d2d2d),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xfff7f9fa),
  onInverseSurface: Color(0xff131313),
  inversePrimary: Color(0xff404a58),
  surfaceTint: Color(0xff748bac),
);

final _baseDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  textTheme: baseTextTheme,
);

final darkTheme = _baseDarkTheme.copyWith(
  textTheme: GoogleFonts.quicksandTextTheme(_baseDarkTheme.textTheme),
);
