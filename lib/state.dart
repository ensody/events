import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event/state.dart';
import 'ticketmaster/api.dart';

/// Everything that can be safely shared across the whole app
/// without unacceptably breaking abstraction boundaries.
class GlobalState {
  GlobalState(this.api);

  final TicketmasterApi api;

  final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey');

  void navigate(Widget target, {bool fullscreenDialog = false}) {
    navigatorKey.currentState.push(MaterialPageRoute<void>(
        builder: (_) => target, fullscreenDialog: fullscreenDialog));
  }

  Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
}

/// The root app state/controller.
///
/// You have to call [initialize] before using this controller.
class AppState {
  AppState(this.global) : event = EventState(global);

  GlobalState global;

  // Here we add state/controllers per subsection of the app.
  EventState event;

  List<SingleChildWidget> get providers => [
        Provider.value(value: global),
        Provider.value(value: event),
      ];

  Completer<bool> _initialized;

  Future<void> initialize() async {
    // Safety measure to prevent multiple initialize() calls from conflicting
    if (_initialized != null) {
      await _initialized.future;
      return;
    }

    _initialized = Completer<bool>();

    await event.initialize();

    _initialized.complete(true);
  }
}
