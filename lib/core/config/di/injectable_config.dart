import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../helper/firebase_store/firebase_store_service.dart';
import 'injectable_config.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init();

  if (!getIt.isRegistered<FirebaseStoreService>()) {
    getIt.registerLazySingleton<FirebaseStoreService>(
      FirebaseStoreService.new,
    );
  }
}

// dart run build_runner build --delete-conflicting-outputs

// flutter clean && cd android && ./gradlew clean && cd ..
// flutter pub get
// flutter build apk --release

// flutter build appbundle --release

// flutter clean
// flutter pub get
// cd ios
// rm -rf Pods Podfile.lock
// pod repo update
// pod install
// cd ..

// ./check_elf_alignment.sh build/app/outputs/flutter-apk/app-release.apk
