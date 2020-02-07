// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonEventsPage _$JsonEventsPageFromJson(Map<String, dynamic> json) {
  return JsonEventsPage(
    links: json['_links'] == null
        ? null
        : JsonLinks.fromJson(json['_links'] as Map<String, dynamic>),
    embedded: json['_embedded'] == null
        ? null
        : JsonEventsEmbedded.fromJson(
            json['_embedded'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$JsonEventsPageToJson(JsonEventsPage instance) =>
    <String, dynamic>{
      '_links': instance.links,
      '_embedded': instance.embedded,
    };

JsonEventsEmbedded _$JsonEventsEmbeddedFromJson(Map<String, dynamic> json) {
  return JsonEventsEmbedded(
    events: (json['events'] as List)
        ?.map((e) =>
            e == null ? null : JsonEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$JsonEventsEmbeddedToJson(JsonEventsEmbedded instance) =>
    <String, dynamic>{
      'events': instance.events,
    };

JsonEvent _$JsonEventFromJson(Map<String, dynamic> json) {
  return JsonEvent(
    id: json['id'] as String,
    type: json['type'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    additionalInfo: json['additionalInfo'] as String,
    url: json['url'] as String,
    distance: (json['distance'] as num)?.toDouble(),
    images: (json['images'] as List)
        ?.map((e) => e == null
            ? null
            : JsonEventImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    dates: json['dates'] == null
        ? null
        : JsonEventDates.fromJson(json['dates'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$JsonEventToJson(JsonEvent instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'additionalInfo': instance.additionalInfo,
      'url': instance.url,
      'distance': instance.distance,
      'images': instance.images,
      'dates': instance.dates,
    };

JsonEventImage _$JsonEventImageFromJson(Map<String, dynamic> json) {
  return JsonEventImage(
    url: json['url'] as String,
    width: json['width'] as int,
    height: json['height'] as int,
    fallback: json['fallback'] as bool,
  );
}

Map<String, dynamic> _$JsonEventImageToJson(JsonEventImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'fallback': instance.fallback,
    };

JsonEventDates _$JsonEventDatesFromJson(Map<String, dynamic> json) {
  return JsonEventDates(
    start: json['start'] == null
        ? null
        : JsonEventStartDate.fromJson(json['start'] as Map<String, dynamic>),
    end: json['end'] == null
        ? null
        : JsonEventEndDate.fromJson(json['end'] as Map<String, dynamic>),
    timezone: json['timezone'] as String,
    spanMultipleDays: json['spanMultipleDays'] as bool,
  );
}

Map<String, dynamic> _$JsonEventDatesToJson(JsonEventDates instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
      'timezone': instance.timezone,
      'spanMultipleDays': instance.spanMultipleDays,
    };

JsonEventStartDate _$JsonEventStartDateFromJson(Map<String, dynamic> json) {
  return JsonEventStartDate(
    dateTime: json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    dateTBD: json['dateTBD'] as bool,
    dateTBA: json['dateTBA'] as bool,
    timeTBA: json['timeTBA'] as bool,
    noSpecificTime: json['noSpecificTime'] as bool,
  )..localDate = json['localDate'] == null
      ? null
      : DateTime.parse(json['localDate'] as String);
}

Map<String, dynamic> _$JsonEventStartDateToJson(JsonEventStartDate instance) =>
    <String, dynamic>{
      'localDate': instance.localDate?.toIso8601String(),
      'dateTime': instance.dateTime?.toIso8601String(),
      'dateTBD': instance.dateTBD,
      'dateTBA': instance.dateTBA,
      'timeTBA': instance.timeTBA,
      'noSpecificTime': instance.noSpecificTime,
    };

JsonEventEndDate _$JsonEventEndDateFromJson(Map<String, dynamic> json) {
  return JsonEventEndDate(
    dateTime: json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    approximate: json['approximate'] as bool,
    noSpecificTime: json['noSpecificTime'] as bool,
  );
}

Map<String, dynamic> _$JsonEventEndDateToJson(JsonEventEndDate instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'approximate': instance.approximate,
      'noSpecificTime': instance.noSpecificTime,
    };

JsonLinks _$JsonLinksFromJson(Map<String, dynamic> json) {
  return JsonLinks(
    next: json['next'] == null
        ? null
        : JsonLink.fromJson(json['next'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$JsonLinksToJson(JsonLinks instance) => <String, dynamic>{
      'next': instance.next,
    };

JsonLink _$JsonLinkFromJson(Map<String, dynamic> json) {
  return JsonLink(
    href: json['href'] as String,
    templated: json['templated'] as bool,
  );
}

Map<String, dynamic> _$JsonLinkToJson(JsonLink instance) => <String, dynamic>{
      'href': instance.href,
      'templated': instance.templated,
    };
