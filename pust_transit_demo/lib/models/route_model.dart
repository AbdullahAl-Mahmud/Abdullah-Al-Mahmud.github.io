import 'package:latlong2/latlong.dart';

class RouteModel {
  const RouteModel({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.path,
    required this.stopIds,
    required this.estimatedDurationMinutes,
  });

  final String id;
  final String name;
  final String origin;
  final String destination;
  final List<LatLng> path;
  final List<String> stopIds;
  final int estimatedDurationMinutes;
}
