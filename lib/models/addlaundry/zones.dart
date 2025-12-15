
class Zone {
  final String id;
  final String title;
  final String time1;
  final String time2;
  final String time3;
  final List<Coordinate> coordinates;

  Zone({
    required this.id,
    required this.title,
    required this.time1,
    required this.time2,
    required this.time3,
    required this.coordinates,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      time1: json['time_1'] ?? '',
      time2: json['time_2'] ?? '',
      time3: json['time_3'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time_1': time1,
        'time_2': time2,
        'time_3': time3,
        'coordinates': coordinates.map((e) => e.toJson()).toList(),
      };
}

class Coordinate {
  final double lat;
  final double lng;

  Coordinate({
    required this.lat,
    required this.lng,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class ZonesResponse {
  final List<Zone> zones;

  ZonesResponse({required this.zones});

  factory ZonesResponse.fromJson(Map<String, dynamic> json) {
    return ZonesResponse(
      zones: (json['zones'] as List<dynamic>? ?? [])
          .map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'zones': zones.map((e) => e.toJson()).toList(),
      };
}

// Example usage:
// final zonesResponse = ZonesResponse.fromJson(jsonDecode(jsonString));
