import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_state/reactive_state.dart';

import '../common/ui/listview.dart';
import 'event_list_item.dart';
import 'favorites_button.dart';
import 'state.dart';

class EventList extends StatefulWidget {
  EventList({Key key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final favoriteChanged = StreamController<void>.broadcast();

  @override
  void dispose() {
    favoriteChanged.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EventState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('EVents'),
        actions: <Widget>[
          FavoritesButton(animationTrigger: favoriteChanged.stream),
        ],
      ),
      body: AutoBuild(
        builder: (context, get, track) {
          var events = get(state.events);
          return InfiniteListView(
            padding: const EdgeInsets.all(8),
            lastLoadedIndex: events.length - 1,
            finished: get(state.finishedLoading),
            loadMore: state.loadNextEventsPage,
            itemBuilder: (context, index) => eventItemBuilder(
                context, state, events[index],
                onFavoriteChanged: favoriteChanged.add),
          );
        },
      ),
    );
  }
}
