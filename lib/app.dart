import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:secure_chat/pages/splash/splash.dart';
import 'package:secure_chat/providers/flavor_service.dart';

import 'constants/app_theme.dart';
import 'generated/i18n.dart';

class MyApp extends StatelessWidget {
  MyApp({this.brightness});

  final router = GetIt.I<Router>();
  final flavorService = GetIt.I<FlavorService>();
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: brightness,
      data: (Brightness brightness) => themeData.copyWith(
        brightness: brightness,
      ),
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate
          ],
          localeResolutionCallback:
              S.delegate.resolution(fallback: const Locale('en', '')),
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: flavorService.isDevelopment(),
          title: S.current.appName,
          theme: theme,
          onGenerateRoute: router.generator,
          home: SplashScreen(),
        );
      },
    );
  }
}
