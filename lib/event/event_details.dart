import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_state/reactive_state.dart';

import '../locale.dart';
import 'models.dart';
import 'state.dart';

class EventDetails extends StatelessWidget {
  EventDetails({Key key, @required this.event}) : super(key: key);

  final Value<Event> event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EVent details'),
      ),
      body: buildEvent(context),
    );
  }

  Widget buildEvent(BuildContext context) {
    final state = Provider.of<EventState>(context);
    // TODO: We really need some better UI design here
    return AutoBuild(builder: (context, get, track) {
      var event = get(this.event);
      bool favorite = state.isFavorite(event);
      var dateRange = formatDateRange(event.start, event.end);
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (event.images.isNotEmpty)
                  Image.network(event.images[0].url, width: 64.0),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(event.name),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(favorite ? Icons.star : Icons.star_border),
                  onPressed: () => state.setFavorite(this.event, !favorite),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (dateRange != null) Text('Date: $dateRange'),
            if (event.description != null) Text(event.description),
            if (event.additionalInfo != null) Text(event.additionalInfo),
          ],
        ),
      );
    });
  }
}
