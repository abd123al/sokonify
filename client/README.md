- in customers tab we may search for payments/pending orders/etc. everything associated with
  customer
- So create customer view page and add tabs like orders.
- add QR code for app linking in the same localhost
- Put expire date in CI so that when app is build only lives for certain amount of days (3 months is
  a life time)
- use C-shared file `.so` for every OS because building `.jar` will need ndk
- add option for configure server during auth so users may
- user should see price changing when adding new items.

## Keys

https://linuxhint.com/bash_base64_encode_decode/

```aidl
base64 keystore.jks > keystore.txt
```

```aidl
flutter run --release
flutter build appbundle --obfuscate --split-debug-info=./build/app/outputs/symbols
flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release
flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release --split-per-abi
```