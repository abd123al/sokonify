- print sales report/price list
- deal with expenses
- fix bug when you try to add item using dicount price which actually dont exisyt
- make sure user has pricing permission
- purchasing order
- hiding items based on permissions
- redirect to inventory page after new product
- search invoice
- expense/brand/unit page view and edit..
- fetch payments by items/products/category
- 
- 
- show item view in tabs show details, sales.
- show stats for categories
- print invoice and receipt from payment page too
- add receipt layout.
- when we click eg total sales show how items contributed to that amount. mfano panadol sold items 20 amount 1000. show na percent comtribution ili mtu afurahie
- Above can be implemented like when we view items/brand/categories pia inaonyesha today stats and it cam even show yearly and montly stats
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