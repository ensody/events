import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ticketmaster/api.dart';

part 'models.g.dart';

@JsonSerializable()
class Event {
  Event(
      {@required this.id,
      this.type,
      this.name,
      this.description,
      this.additionalInfo,
      this.url,
      this.distance,
      this.images,
      this.start,
      this.end});

  // TODO: Convert to event-local time (currently leaving in UTC)
  factory Event.fromJsonEvent(JsonEvent event) => Event(
      id: event.id,
      type: event.type,
      name: event.name,
      description: event.description,
      additionalInfo: event.additionalInfo,
      url: event.url,
      distance: event.distance,
      images: [
        for (var image in event.images ?? <JsonEventImage>[])
          EventImage.fromJsonEventImage(image)
      ],
      start: event.dates?.start?.dateTime,
      end: event.dates?.end?.dateTime);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  final String id;
  final String type;
  final String name;
  final String description;
  final String additionalInfo;
  final String url;
  final double distance;
  final List<EventImage> images;
  final DateTime start;
  final DateTime end;
}

@JsonSerializable()
class EventImage {
  EventImage({this.url, this.width, this.height, this.fallback});

  factory EventImage.fromJsonEventImage(JsonEventImage image) => EventImage(
      url: image.url,
      width: image.width,
      height: image.height,
      fallback: image.fallback);

  factory EventImage.fromJson(Map<String, dynamic> json) =>
      _$EventImageFromJson(json);

  Map<String, dynamic> toJson() => _$EventImageToJson(this);

  final String url;
  final int width;
  final int height;
  final bool fallback;
}
