flutter run --release
flutter build appbundle --obfuscate --split-debug-info=./build/app/outputs/symbols
flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release
flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release --split-per-abi

