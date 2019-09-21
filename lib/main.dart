import 'dart:io';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import 'core/services/api.dart';
import 'locator.dart';
import 'ui/router.dart';
import 'utils/Translations.dart';
import 'utils/constants.dart';
import 'utils/utils.dart';


Future<Null> main() async {
  await setupLocator();
  await Translations.load(Locale(await Platform.localeName));
//  runApp(MyApp());
  runApp(HomeAnotations());
}


class HomeAnotations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      StreamProvider(
      builder: (context) => locator<Api>().userController,
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
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
          primaryColor: Colors.white,
//          primaryColor: parseColor(COLOR_DEFAULT),
          accentColor: colorParse(hexCode: COLOR_DEFAULT),
//          accentColor: parseColor(OUTHER_COLOR_DEFAULT),
        ),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}