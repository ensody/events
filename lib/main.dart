import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event/event_list.dart';
import 'secrets.dart';
import 'state.dart';
import 'ticketmaster/api.dart';

void main() {
  final api = TicketmasterApi(TicketmasterApiKey);
  final global = GlobalState(api);
  final state = AppState(global);
  runApp(EventsApp(state));
}

class EventsApp extends StatelessWidget {
  EventsApp(this.state);

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: state.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return MultiProvider(
              providers: [Provider.value(value: state)]
                ..addAll(state.providers),
              child: MaterialApp(
                title: 'Events',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                navigatorKey: state.global.navigatorKey,
                home: EventList(),
              ));
        });
  }
}
