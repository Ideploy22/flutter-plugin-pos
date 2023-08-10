import 'package:ideploy_package/ideploy_package.dart';

import 'injectable.config.dart';

final GetIt locator = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void init() {
  if (!locator.isRegistered<HiveInterface>()) {
    locator.registerFactory(() => Hive);
  }

  $initGetIt(locator);
}
