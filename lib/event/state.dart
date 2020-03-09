import 'dart:async';

import 'package:reactive_state/reactive_state.dart';

import '../state.dart';
import '../ticketmaster/api.dart';
import 'models.dart';
import 'favorites_cache.dart';

class EventState {
  EventState(this.global);

  Future<void> initialize() async {
    favorites = FavoritesCache(await global.getPrefs());
  }

  // TODO: It would be nicer to only keep a subset of all pages in RAM.
  /// This contains all events we've ever paginated through.
  final events = ListValue(<Value<Event>>[]);

  /// Whether we've paginated to the end of the events result list
  var finishedLoading = Value(false);

  /// Manages favorite events.
  FavoritesCache favorites;

  final GlobalState global;

  int _page = 0;

  void loadNextEventsPage() async {
    // IMPORTANT: We try to share the same instance of Value between the
    // favorites and events lists, so widgets listen to the same observables.

    // TODO: Instead of using page numbers we should probably work with some
    // pagination cursor - if the API allows that.
    final result = await global.api.getEvents(page: _page);

    final added = <Value<Event>>[];
    for (var jsonEvent in result.embedded?.events ?? <JsonEvent>[]) {
      final event = Event.fromJsonEvent(jsonEvent);
      // Check if we already have a Value instance for this event
      if (favorites.isFavorite(event)) {
        added.add(favorites.getById(event.id)..value = event);
      } else {
        added.add(Value(event));
      }
    }
    _page += 1;
    events.addAll(added);

    if (result?.links?.next == null) {
      finishedLoading.value = true;
    }
  }
}
