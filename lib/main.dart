import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/data/preferences.dart';
import 'package:flutter_annotations/ui/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'bloc/theme_bloc.dart';
import 'utils/Translations.dart';
import 'package:bloc/bloc.dart';

Future<Null> main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await Tools.init();
  await Translations.load(Locale(await Platform.localeName));
  runApp(HomeAnotations());
}

class HomeAnotations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      builder: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return
            MaterialApp(
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
            theme: theme,
            initialRoute: '/',
            onGenerateRoute: Router.generateRoute,

          );
        },
      ),
    );
  }
}