import 'package:flutter/material.dart';
import 'package:reactive_state/reactive_state.dart';

import '../locale.dart';
import 'event_details.dart';
import 'models.dart';
import 'state.dart';

Widget eventItemBuilder(
    BuildContext context, EventState state, Value<Event> eventValue,
    {void Function(Value<Event> eventValue) onFavoriteChanged}) {
  return AutoBuild(
      key: ValueKey(eventValue.value.id),
      builder: (context, get, track) {
        var event = get(eventValue);
        bool favorite = state.favorites.isFavorite(event);
        var dateRange = formatDateRange(event.start, event.end);
        return ListTile(
          onTap: () => state.global.navigate(EventDetails(event: eventValue)),
          leading: event.images.isNotEmpty
              ? Image.network(event.images[0].url, width: 48.0)
              : null,
          title: Text(event.name),
          subtitle: Text(dateRange ?? ''),
          trailing: IconButton(
            icon: Icon(favorite ? Icons.star : Icons.star_border),
            onPressed: () {
              state.favorites.setFavorite(eventValue, !favorite);
              if (onFavoriteChanged != null) {
                onFavoriteChanged(eventValue);
              }
            },
          ),
        );
      });
}
