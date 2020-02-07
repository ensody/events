import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../common/api/base.dart';
import '../common/api/json.dart';

part 'api.g.dart';

class TicketmasterApi extends JsonApi {
  TicketmasterApi(this.apiKey, {http.Client client})
      : super(
            baseUrl: 'https://app.ticketmaster.com/discovery/v2/',
            client: client);

  final String apiKey;

  @override
  Map<String, List<String>> get queryParameters => {
        'apikey': [apiKey],
      };

  @override
  http.Response handleResponse(http.Response response) {
    if (response.statusCode >= 400 || response.statusCode < 200) {
      throw ApiException('Request failed', response);
    }
    return response;
  }

  String formatDateTime(DateTime dateTime) =>
      dateTime.toIso8601String().split('.')[0] + 'Z';

  Future<JsonEventsPage> getEvents({int page = 0, int size = 50}) async {
    return JsonEventsPage.fromJson(await getJson('events.json', query: {
      'page': ['$page'],
      'size': ['$size'],
      'sort': ['date,asc'],
      'startDateTime': [formatDateTime(DateTime.now())],
      // TODO: Add location support (requires calculating geoHash since
      // latlong parameter is deprecated)
      // FIXME: Currently hard-coded to Hamburg
      'geoPoint': ['u1x0etbfu'],
      'units': ['km'],
      // TODO: take user locale into account
      'locale': ['de'],
    }));
  }
}

@JsonSerializable()
class JsonEventsPage {
  @JsonKey(ignore: true)
  Map<String, dynamic> originalJson;

  @JsonKey(name: '_links')
  final JsonLinks links;

  @JsonKey(name: '_embedded')
  final JsonEventsEmbedded embedded;

  JsonEventsPage({this.links, this.embedded});

  factory JsonEventsPage.fromJson(Map<String, dynamic> json) =>
      _$JsonEventsPageFromJson(json)..originalJson = json;

  Map<String, dynamic> toJson() => _$JsonEventsPageToJson(this);
}

@JsonSerializable()
class JsonEventsEmbedded {
  final List<JsonEvent> events;

  JsonEventsEmbedded({this.events});

  factory JsonEventsEmbedded.fromJson(Map<String, dynamic> json) =>
      _$JsonEventsEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEventsEmbeddedToJson(this);
}

@JsonSerializable()
class JsonEvent {
  @JsonKey(ignore: true)
  Map<String, dynamic> originalJson;

  String id;
  String type;
  String name;
  String description;
  String additionalInfo;
  String url;
  double distance;
  List<JsonEventImage> images;
  JsonEventDates dates;

  JsonEvent(
      {this.id,
      this.type,
      this.name,
      this.description,
      this.additionalInfo,
      this.url,
      this.distance,
      this.images,
      this.dates});

  factory JsonEvent.fromJson(Map<String, dynamic> json) =>
      _$JsonEventFromJson(json)..originalJson = json;

  Map<String, dynamic> toJson() => _$JsonEventToJson(this);
}

@JsonSerializable()
class JsonEventImage {
  String url;
  int width;
  int height;
  bool fallback;

  JsonEventImage({this.url, this.width, this.height, this.fallback});

  factory JsonEventImage.fromJson(Map<String, dynamic> json) =>
      _$JsonEventImageFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEventImageToJson(this);
}

@JsonSerializable()
class JsonEventDates {
  JsonEventStartDate start;
  JsonEventEndDate end;
  String timezone;
  bool spanMultipleDays;

  JsonEventDates({this.start, this.end, this.timezone, this.spanMultipleDays});

  factory JsonEventDates.fromJson(Map<String, dynamic> json) =>
      _$JsonEventDatesFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEventDatesToJson(this);
}

@JsonSerializable()
class JsonEventStartDate {
  DateTime localDate;
  DateTime dateTime;
  bool dateTBD;
  bool dateTBA;
  bool timeTBA;
  bool noSpecificTime;

  JsonEventStartDate(
      {this.dateTime,
      this.dateTBD,
      this.dateTBA,
      this.timeTBA,
      this.noSpecificTime});

  factory JsonEventStartDate.fromJson(Map<String, dynamic> json) =>
      _$JsonEventStartDateFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEventStartDateToJson(this);
}

@JsonSerializable()
class JsonEventEndDate {
  DateTime dateTime;
  bool approximate;
  bool noSpecificTime;

  JsonEventEndDate({this.dateTime, this.approximate, this.noSpecificTime});

  factory JsonEventEndDate.fromJson(Map<String, dynamic> json) =>
      _$JsonEventEndDateFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEventEndDateToJson(this);
}

@JsonSerializable()
class JsonLinks {
  @JsonKey(required: false)
  final JsonLink next;

  JsonLinks({this.next});

  factory JsonLinks.fromJson(Map<String, dynamic> json) =>
      _$JsonLinksFromJson(json);

  Map<String, dynamic> toJson() => _$JsonLinksToJson(this);
}

@JsonSerializable()
class JsonLink {
  final String href;
  final bool templated;

  JsonLink({this.href, this.templated});

  factory JsonLink.fromJson(Map<String, dynamic> json) =>
      _$JsonLinkFromJson(json);

  Map<String, dynamic> toJson() => _$JsonLinkToJson(this);
}
