import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_state/reactive_state.dart';

import 'event_list_item.dart';
import 'state.dart';

class FavoritesList extends StatelessWidget {
  FavoritesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EventState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite EVents'),
      ),
      body: AutoBuild(
        builder: (context, get, track) {
          final favorites = get(state.favorites);
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favorites.length,
            itemBuilder: (context, index) =>
                eventItemBuilder(context, state, favorites[index]),
          );
        },
      ),
    );
  }
}
