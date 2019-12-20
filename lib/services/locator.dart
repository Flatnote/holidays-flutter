import 'package:holidays/services/api_service.dart';
import 'package:holidays/services/dialog_service.dart';
import 'package:holidays/services/entry_service.dart';
import 'package:holidays/services/user_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerLazySingleton(() => EntryService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => DialogService());
}
