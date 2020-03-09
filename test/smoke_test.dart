import 'package:events/common/api/json.dart';
import 'package:events/main.dart';
import 'package:events/state.dart';
import 'package:events/ticketmaster/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements http.Client {}

class MockApi extends TicketmasterApi {
  MockApi() : super('', client: MockClient());
}

class TestGlobalState extends GlobalState {
  TestGlobalState(TicketmasterApi api) : super(api);

  @override
  Future<SharedPreferences> getPrefs() async => null;
}

http.StreamedResponse jsonResponse(Object data, int statusCode) =>
    http.StreamedResponse(Stream.value(encodeJson(data)), statusCode);

Null matchesArg<T>(bool Function(T x) f) => argThat(predicate<T>(f));

Null matchesRequest(String method, String path) =>
    matchesArg<http.Request>((r) => r.method == method && r.url.path == path);

void main() {
  testWidgets('favorites', (WidgetTester tester) async {
    final api = MockApi();
    final global = TestGlobalState(api);
    final state = AppState(global);
    final app = EventsApp(state);

    when(api.client.send(matchesRequest('GET', '/discovery/v2/events.json')))
        .thenAnswer((_) async {
      return jsonResponse({
        '_embedded': {
          'events': [
            {
              'id': 'ev1',
              'name': 'SomeEvent',
            },
            {
              'id': 'ev2',
              'name': 'OtherEvent',
            },
          ]
        },
      }, 200);
    });

    // State/controller initialization
    await tester.pumpWidget(app);
    // Loading of events
    await tester.pumpWidget(app);
    // Rendering of events
    await tester.pumpWidget(app);

    expect(state.event.events.value.length, equals(2));
    expect(find.text('SomeEvent'), findsOneWidget);
    expect(find.text('OtherEvent'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));

    // Set favorite
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pumpWidget(app);
    expect(state.event.favorites.isFavorite(state.event.events.value[0].value),
        isTrue);
    expect(state.event.favorites.isFavorite(state.event.events.value[1].value),
        isFalse);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
    state.event.favorites.setFavorite(state.event.events.value[1], true);
    await tester.pumpWidget(app);
    expect(find.byIcon(Icons.star), findsNWidgets(2));
    state.event.favorites.setFavorite(state.event.events.value[1], false);
    await tester.pumpWidget(app);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);

    // Open details
    await tester.tap(find.text('SomeEvent'));
    await tester.pumpAndSettle();
    expect(find.text('SomeEvent'), findsOneWidget);
    expect(find.text('OtherEvent'), findsNothing);
    expect(find.byIcon(Icons.star), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Open favorites
    await tester.tap(find.byIcon(Icons.stars));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star_border), findsNothing);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('SomeEvent'), findsOneWidget);
    expect(find.text('OtherEvent'), findsNothing);

    // Remove favorite
    await tester.tap(find.byIcon(Icons.star));
    await tester.pumpWidget(app);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });
}
