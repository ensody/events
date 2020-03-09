# Events

Events is a simple [reactive_state](https://pub.dev/packages/reactive_state) demo for searching events using the Ticketmaster API.

This sample app shows how to use dependency injection and state handling.

## Getting started

You have to add a `lib/secrets.dart` file containing your API keys:

```dart
const TicketmasterApiKey = 'YOURAPIKEY';
```

## Tests

Run tests with:

```sh
flutter test
```

## Generated code

When changing the JSON API objects marked with `@JsonSerializable` you have to rebuild the generated API objects with:

```sh
flutter packages pub run build_runner build
```

Instead of "build" you can also run "watch" to keep rebuilding on-demand.
