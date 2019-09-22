import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'ui/router.dart';
import 'utils/Translations.dart';

var blackMode = true;

Future<Null> main() async {
  Styles.iniTheme();
  await setupLocator();
  await Translations.load(Locale(await Platform.localeName));
  runApp(HomeAnotations());
}

class HomeAnotations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      builder: (context) => StreamController(),
      child: MaterialApp(
        supportedLocales: [
          const Locale('pt', 'PT'),
          const Locale('es', 'ES'),
          const Locale('en', 'US'),
          Translations.current.currentLanguage
        ],
        localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData,
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
