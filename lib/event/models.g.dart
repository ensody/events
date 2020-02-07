// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as String,
    type: json['type'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    additionalInfo: json['additionalInfo'] as String,
    url: json['url'] as String,
    distance: (json['distance'] as num)?.toDouble(),
    images: (json['images'] as List)
        ?.map((e) =>
            e == null ? null : EventImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'additionalInfo': instance.additionalInfo,
      'url': instance.url,
      'distance': instance.distance,
      'images': instance.images,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };

EventImage _$EventImageFromJson(Map<String, dynamic> json) {
  return EventImage(
    url: json['url'] as String,
    width: json['width'] as int,
    height: json['height'] as int,
    fallback: json['fallback'] as bool,
  );
}

Map<String, dynamic> _$EventImageToJson(EventImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'fallback': instance.fallback,
    };
