import 'package:anotacoes/core/data/preferences.dart';
import 'package:anotacoes/viewmodel/anotation_model.dart';
import 'package:anotacoes/viewmodel/content_model.dart';
import 'package:get_it/get_it.dart';

import 'core/services/api.dart';

GetIt locator = GetIt();

void setupLocator() async {
//  locator.registerLazySingleton(() => AuthenticationService());
  await Tools.init();
  locator.registerLazySingleton(() => Api());
  locator.registerFactory(() => AnotationModel());
  locator.registerFactory(() => ContentModel());
}
