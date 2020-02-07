import 'dart:async';
import 'dart:convert';

import 'package:reactive_state/reactive_state.dart';

import '../common/api/json.dart';
import '../state.dart';
import '../ticketmaster/api.dart';
import 'models.dart';

class EventState {
  // IMPORTANT: We try to share the same instance of Value between the favorites
  // and events lists, so widgets listen to the same instances.

  EventState(this.global) {
    eventsMap = events.toMap((event) => MapEntry(event.value.id, event));

    // TODO: Construct a ListValue by tracking list and map change events
    favorites = DerivedValue((get, track) {
      final eventsMap = get(this.eventsMap);
      final favoritesCache = get(this.favoritesCache);
      final result = <Value<Event>>[];
      for (var item in eventsMap.values) {
        if (favoritesCache.containsKey(item.value.id)) {
          result.add(item);
        }
      }
      for (var id in favoritesCache.keys.toSet()..removeAll(eventsMap.keys)) {
        result.add(favoritesCache[id]);
      }
      return List.unmodifiable(result);
    });
  }

  // This contains all events we've ever paginated through.
  // TODO: It would be nicer to only keep a subset of all pages in RAM.
  final events = ListValue(<Value<Event>>[]);

  // Whether we've paginated to the end of the events result list
  var finishedLoading = Value(false);
  DerivedValue<List<Value<Event>>> favorites;
  final GlobalState global;

  int _page = 0;
  BaseMapValue<String, Value<Event>> eventsMap;

  // We store the all event objects as JSON, so we can retrieve them even if
  // none of our queries return them.
  // TODO: At some point we should store in a DB instead of SharedPreferences
  static const _FAVORITES_KEY = 'favorites';
  final favoritesCache = Value(<String, Value<Event>>{});

  Future<void> initialize() async {
    final prefs = await global.getPrefs();
    favoritesCache.update((favoritesCache) {
      for (var item in prefs?.getStringList(_FAVORITES_KEY) ?? <String>[]) {
        final event = Event.fromJson(decodeJson(item));
        favoritesCache[event.id] = Value(event);
      }
    });
  }

  bool isFavorite(Event event) => favoritesCache.value.containsKey(event.id);

  void setFavorite(Value<Event> event, bool favorite) async {
    final prefs = await global.getPrefs();
    favoritesCache.update((favoritesCache) {
      var id = event.value.id;
      if (favorite) {
        favoritesCache[id] = eventsMap.value[id];
      } else {
        favoritesCache.remove(id);
      }
      prefs?.setStringList(_FAVORITES_KEY,
          [for (var e in favoritesCache.values) json.encode(e.value.toJson())]);
    });

    // Notify listeners
    event.update((_) {});
  }

  void loadNextEventsPage() async {
    // TODO: Instead of using page numbers we should probably work with some
    // pagination cursor - if the API allows that.
    final result = await global.api.getEvents(page: _page);

    final added = <Value<Event>>[];
    for (var jsonEvent in result.embedded?.events ?? <JsonEvent>[]) {
      final event = Event.fromJsonEvent(jsonEvent);
      // Check if we already have a Value instance for this event
      if (favoritesCache.value.containsKey(event.id)) {
        added.add(favoritesCache.value[event.id]..value = event);
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
