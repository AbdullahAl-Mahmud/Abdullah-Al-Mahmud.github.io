import 'package:latlong2/latlong.dart';

class BusStopModel {
  const BusStopModel({
    required this.id,
    required this.name,
    required this.position,
  });

  final String id;
  final String name;
  final LatLng position;
}
