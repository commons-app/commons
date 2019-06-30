# Commons App for IOS

[![Build status](https://api.travis-ci.org/maskaravivek/commons.svg?branch=master)](https://travis-ci.org/maskaravivek/commons)

App to upload pictures to Commons

## Generating JSON serializable methods

```
flutter pub run build_runner build --delete-conflicting-outputs
```

or else use 

https://javiercbk.github.io/json_to_dart/

## Localisation

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n \
   --no-use-deferred-loading lib/helper/localizations.dart lib/l10n/intl_*.arb
```


## Running the app

### Beta variant

```
flutter run -t lib/main_beta.dart
```

### Prod variant

```
flutter run -t lib/main_prod.dart
```
