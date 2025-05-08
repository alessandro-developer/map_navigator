# On terminal first run the command: "sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc" 
# and then run the command: "sh app_init.sh"

dart fix --dry-run
dart fix --apply
dart pub global activate flutterfire_cli
flutter clean
flutter pub get
flutter pub upgrade
flutter pub upgrade --major-versions
flutter precache --android
flutter precache --ios
cd ios
pod install
pod repo update
pod update
cd ..
flutter pub get