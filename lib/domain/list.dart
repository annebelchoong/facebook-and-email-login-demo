import 'package:flutter/foundation.dart' show immutable;

@immutable
class Listing {
  final String id;
  final String listName;
  final String distance;

  const Listing({
    required this.id,
    required this.listName,
    required this.distance,
  });

  String get getId => id;
  String get getName => listName;
  String get getDistance => distance;

  Listing.fromJson(Map json)
      : id = json['id'],
        listName = json['list_name'],
        distance = json['distance'];
}
