
import 'package:get_it/get_it.dart';

import 'core/data/preferences.dart';
import 'core/services/api.dart';
import 'viewmodel/anotation_model.dart';
import 'viewmodel/content_model.dart';

GetIt locator = GetIt();

void setupLocator() async {
//  locator.registerLazySingleton(() => AuthenticationService());
  await Tools.init();
  locator.registerLazySingleton(() => Api());
  locator.registerFactory(() => AnotationModel());
  locator.registerFactory(() => ContentModel());
}
