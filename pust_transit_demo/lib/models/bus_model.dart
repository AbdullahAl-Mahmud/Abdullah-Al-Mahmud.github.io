import 'package:latlong2/latlong.dart';

enum BusStatus { running, delayed, onTime, stopped }

extension BusStatusX on BusStatus {
  String get label => switch (this) {
        BusStatus.running => 'Running',
        BusStatus.delayed => 'Delayed',
        BusStatus.onTime => 'On Time',
        BusStatus.stopped => 'Stopped',
      };
}

class BusModel {
  const BusModel({
    required this.id,
    required this.name,
    required this.routeId,
    required this.driverId,
    required this.registration,
    required this.status,
    required this.position,
    required this.currentSpeed,
    required this.etaMinutes,
    required this.seatsAvailable,
    required this.currentStop,
    required this.nextStop,
    required this.pathIndex,
    required this.segmentProgress,
    required this.lastUpdated,
  });

  final String id;
  final String name;
  final String routeId;
  final String driverId;
  final String registration;
  final BusStatus status;
  final LatLng position;
  final double currentSpeed;
  final int etaMinutes;
  final int seatsAvailable;
  final String currentStop;
  final String nextStop;
  final int pathIndex;
  final double segmentProgress;
  final DateTime lastUpdated;

  BusModel copyWith({
    BusStatus? status,
    LatLng? position,
    double? currentSpeed,
    int? etaMinutes,
    int? seatsAvailable,
    String? currentStop,
    String? nextStop,
    int? pathIndex,
    double? segmentProgress,
    DateTime? lastUpdated,
  }) {
    return BusModel(
      id: id,
      name: name,
      routeId: routeId,
      driverId: driverId,
      registration: registration,
      status: status ?? this.status,
      position: position ?? this.position,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      seatsAvailable: seatsAvailable ?? this.seatsAvailable,
      currentStop: currentStop ?? this.currentStop,
      nextStop: nextStop ?? this.nextStop,
      pathIndex: pathIndex ?? this.pathIndex,
      segmentProgress: segmentProgress ?? this.segmentProgress,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
