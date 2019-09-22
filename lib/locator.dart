
import 'package:get_it/get_it.dart';

import 'core/data/preferences.dart';
import 'viewmodel/anotation_model.dart';
import 'viewmodel/content_model.dart';

GetIt locator = GetIt();

void setupLocator() async {
  await Tools.init();
  locator.registerLazySingleton(() => AnotationModel());
  locator.registerLazySingleton(() => ContentModel());
//  locator.registerFactory(() => AnotationModel());
//  locator.registerFactory(() => ContentModel());

}
