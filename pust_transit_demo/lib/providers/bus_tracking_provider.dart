import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus_model.dart';
import '../services/mock_data_service.dart';

class BusTrackingNotifier extends Notifier<List<BusModel>> {
  Timer? _timer;
  int _tick = 0;

  @override
  List<BusModel> build() {
    ref.onDispose(() => _timer?.cancel());
    _timer ??= Timer.periodic(
      const Duration(seconds: 2),
      (_) => _advanceBuses(),
    );
    return MockDataService.initialBuses();
  }

  void _advanceBuses() {
    _tick += 1;
    state = <BusModel>[
      for (var i = 0; i < state.length; i++) _advanceBus(state[i], i),
    ];
  }

  BusModel _advanceBus(BusModel bus, int busIndex) {
    final route = MockDataService.routeById(bus.routeId);
    var pathIndex = bus.pathIndex;
    var progress = bus.segmentProgress + 0.20 + (busIndex * 0.035);
    var passedSegment = false;

    while (progress >= 1) {
      progress -= 1;
      pathIndex += 1;
      passedSegment = true;
      if (pathIndex >= route.path.length - 1) {
        pathIndex = 0;
      }
    }

    final start = route.path[pathIndex];
    final end = route.path[pathIndex + 1];
    final position = LatLng(
      start.latitude + ((end.latitude - start.latitude) * progress),
      start.longitude + ((end.longitude - start.longitude) * progress),
    );

    final rawStopIndex =
        ((pathIndex / (route.path.length - 1)) * route.stopIds.length).floor();
    final stopIndex = math.min(
      math.max(rawStopIndex, 0),
      route.stopIds.length - 1,
    );
    final nextStopIndex = math.min(stopIndex + 1, route.stopIds.length - 1);
    final currentStop = MockDataService.stopById(route.stopIds[stopIndex]).name;
    final nextStop = MockDataService.stopById(route.stopIds[nextStopIndex]).name;

    var eta = bus.etaMinutes;
    if (passedSegment && _tick.isEven) {
      eta = eta <= 1 ? route.estimatedDurationMinutes : eta - 1;
    }

    final baseSpeed = switch (bus.status) {
      BusStatus.delayed => 15.0,
      BusStatus.stopped => 0.0,
      BusStatus.running => 28.0,
      BusStatus.onTime => 31.0,
    };
    final speedVariation = ((_tick + busIndex) % 5) - 2;

    return bus.copyWith(
      position: position,
      currentSpeed: math.max(0.0, baseSpeed + speedVariation),
      etaMinutes: eta,
      currentStop: currentStop,
      nextStop: nextStop,
      pathIndex: pathIndex,
      segmentProgress: progress,
      lastUpdated: DateTime.now(),
    );
  }

  void reset() {
    state = MockDataService.initialBuses();
  }
}

final busTrackingProvider =
    NotifierProvider<BusTrackingNotifier, List<BusModel>>(
  BusTrackingNotifier.new,
);
