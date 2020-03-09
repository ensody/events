import 'dart:async';
import 'dart:convert';

import 'package:reactive_state/reactive_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/api/json.dart';
import '../state.dart';
import '../ticketmaster/api.dart';
import 'models.dart';

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

/// Caches favorite events in RAM as a [ValueListenable] of [List] of [Value]
/// of [Event].
///
/// Changes to the favorite state trigger a notification on `Value<Event>`.
class FavoritesCache extends DerivedValue<List<Value<Event>>> {
  factory FavoritesCache(SharedPreferences prefs) {
    FavoritesCache cache;
    cache = FavoritesCache._(prefs, (get, track) {
      var now = DateTime.now();
      return List.unmodifiable(get(cache._byId).values.toList()
        ..sort((x, y) {
          return (x.value.start ?? now).compareTo(y.value.start ?? now);
        }));
    });
    return cache;
  }

  FavoritesCache._(
      SharedPreferences prefs, AutoRunCallback<List<Value<Event>>> func)
      : _db = FavoritesDB(prefs),
        super(func) {
    _load();
  }

  /// Favorites mapped from [Event.id] to [Event]
  final _byId = Value(<String, Value<Event>>{});

  final FavoritesDB _db;

  Future<void> setFavorite(Value<Event> event, bool favorite) async {
    _byId.update((byId) {
      var id = event.value.id;
      if (favorite) {
        byId[id] = event;
      } else {
        byId.remove(id);
      }
    });
    await _save();

    // Notify listeners
    event.update((_) {});
  }

  bool isFavorite(Event event) => _byId.value.containsKey(event.id);

  Value<Event> getById(String id) => _byId.value[id];

  void _load() {
    _byId.update((byId) {
      for (var event in _db.load()) {
        byId[event.id] = Value(event);
      }
    });
  }

  Future<void> _save() async {
    await _db.save(_byId.value.values.map((v) => v.value));
  }
}

// TODO: At some point we should store in SQLite instead of SharedPreferences
// We store whole event objects as JSON, so we can retrieve them even if we
// haven't yet loaded them via the API.
class FavoritesDB {
  FavoritesDB(this._prefs);

  final SharedPreferences _prefs;
  static const _FAVORITES_KEY = 'favorites';

  List<Event> load() {
    return <Event>[
      for (var item in _prefs?.getStringList(_FAVORITES_KEY) ?? <String>[])
        Event.fromJson(decodeJson(item))
    ];
  }

  Future<void> save(Iterable<Event> events) async {
    await _prefs?.setStringList(
        _FAVORITES_KEY, [for (var e in events) json.encode(e.toJson())]);
  }
}
