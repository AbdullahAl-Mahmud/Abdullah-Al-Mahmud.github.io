import 'package:latlong2/latlong.dart';

import '../models/announcement_model.dart';
import '../models/bus_model.dart';
import '../models/bus_stop_model.dart';
import '../models/driver_model.dart';
import '../models/route_model.dart';
import '../models/schedule_model.dart';

abstract final class MockDataService {
  static final List<BusStopModel> stops = <BusStopModel>[
    const BusStopModel(
      id: 's1',
      name: 'PUST Main Gate',
      position: LatLng(24.0064, 89.2493),
    ),
    const BusStopModel(
      id: 's2',
      name: 'PUST Academic Zone',
      position: LatLng(24.0080, 89.2510),
    ),
    const BusStopModel(
      id: 's3',
      name: 'Rajapur Junction',
      position: LatLng(24.0162, 89.2420),
    ),
    const BusStopModel(
      id: 's4',
      name: 'Pabna Bus Terminal',
      position: LatLng(24.0277, 89.2388),
    ),
    const BusStopModel(
      id: 's5',
      name: 'Pabna Town Hall',
      position: LatLng(24.0108, 89.2373),
    ),
    const BusStopModel(
      id: 's6',
      name: 'Ataikula Road',
      position: LatLng(24.0460, 89.2040),
    ),
    const BusStopModel(
      id: 's7',
      name: 'Dashuria More',
      position: LatLng(24.1020, 89.1130),
    ),
    const BusStopModel(
      id: 's8',
      name: 'Ishwardi Station',
      position: LatLng(24.1282, 89.0660),
    ),
    const BusStopModel(
      id: 's9',
      name: 'Kashinathpur',
      position: LatLng(23.9750, 89.3040),
    ),
    const BusStopModel(
      id: 's10',
      name: 'Bera Bus Stand',
      position: LatLng(23.9500, 89.3720),
    ),
  ];

  static final List<RouteModel> routes = <RouteModel>[
    RouteModel(
      id: 'r1',
      name: 'PUST → Pabna Town',
      origin: 'PUST Main Gate',
      destination: 'Pabna Town Hall',
      estimatedDurationMinutes: 25,
      stopIds: const ['s1', 's2', 's3', 's4', 's5'],
      path: const [
        LatLng(24.0064, 89.2493),
        LatLng(24.0072, 89.2500),
        LatLng(24.0080, 89.2510),
        LatLng(24.0105, 89.2485),
        LatLng(24.0135, 89.2450),
        LatLng(24.0162, 89.2420),
        LatLng(24.0202, 89.2407),
        LatLng(24.0240, 89.2398),
        LatLng(24.0277, 89.2388),
        LatLng(24.0220, 89.2377),
        LatLng(24.0161, 89.2374),
        LatLng(24.0108, 89.2373),
      ],
    ),
    RouteModel(
      id: 'r2',
      name: 'PUST → Ishwardi',
      origin: 'PUST Main Gate',
      destination: 'Ishwardi Station',
      estimatedDurationMinutes: 70,
      stopIds: const ['s1', 's3', 's6', 's7', 's8'],
      path: const [
        LatLng(24.0064, 89.2493),
        LatLng(24.0162, 89.2420),
        LatLng(24.0270, 89.2270),
        LatLng(24.0460, 89.2040),
        LatLng(24.0610, 89.1820),
        LatLng(24.0790, 89.1550),
        LatLng(24.1020, 89.1130),
        LatLng(24.1110, 89.0950),
        LatLng(24.1200, 89.0780),
        LatLng(24.1282, 89.0660),
      ],
    ),
    RouteModel(
      id: 'r3',
      name: 'PUST → Bera',
      origin: 'PUST Main Gate',
      destination: 'Bera Bus Stand',
      estimatedDurationMinutes: 60,
      stopIds: const ['s1', 's2', 's9', 's10'],
      path: const [
        LatLng(24.0064, 89.2493),
        LatLng(24.0080, 89.2510),
        LatLng(24.0030, 89.2640),
        LatLng(23.9950, 89.2800),
        LatLng(23.9850, 89.2940),
        LatLng(23.9750, 89.3040),
        LatLng(23.9670, 89.3210),
        LatLng(23.9600, 89.3400),
        LatLng(23.9550, 89.3570),
        LatLng(23.9500, 89.3720),
      ],
    ),
  ];

  static const List<DriverModel> drivers = <DriverModel>[
    DriverModel(
      id: 'd1',
      name: 'Md. Kamal Hossain',
      phone: '+880 1700-000001',
      experienceYears: 12,
    ),
    DriverModel(
      id: 'd2',
      name: 'Md. Rafiq Islam',
      phone: '+880 1700-000002',
      experienceYears: 9,
    ),
    DriverModel(
      id: 'd3',
      name: 'Md. Shahin Ahmed',
      phone: '+880 1700-000003',
      experienceYears: 11,
    ),
  ];

  static List<BusModel> initialBuses() {
    final now = DateTime.now();
    return <BusModel>[
      BusModel(
        id: 'b1',
        name: 'Bus 01',
        routeId: 'r1',
        driverId: 'd1',
        registration: 'PUST-BUS-01',
        status: BusStatus.running,
        position: routes[0].path[1],
        currentSpeed: 28,
        etaMinutes: 6,
        seatsAvailable: 18,
        currentStop: 'PUST Main Gate',
        nextStop: 'PUST Academic Zone',
        pathIndex: 1,
        segmentProgress: 0.15,
        lastUpdated: now,
      ),
      BusModel(
        id: 'b2',
        name: 'Bus 02',
        routeId: 'r2',
        driverId: 'd2',
        registration: 'PUST-BUS-02',
        status: BusStatus.delayed,
        position: routes[1].path[2],
        currentSpeed: 12,
        etaMinutes: 18,
        seatsAvailable: 9,
        currentStop: 'Rajapur Junction',
        nextStop: 'Ataikula Road',
        pathIndex: 2,
        segmentProgress: 0.40,
        lastUpdated: now,
      ),
      BusModel(
        id: 'b3',
        name: 'Bus 03',
        routeId: 'r3',
        driverId: 'd3',
        registration: 'PUST-BUS-03',
        status: BusStatus.onTime,
        position: routes[2].path[3],
        currentSpeed: 31,
        etaMinutes: 11,
        seatsAvailable: 24,
        currentStop: 'PUST Academic Zone',
        nextStop: 'Kashinathpur',
        pathIndex: 3,
        segmentProgress: 0.30,
        lastUpdated: now,
      ),
    ];
  }

  static const List<ScheduleModel> schedules = <ScheduleModel>[
    ScheduleModel(
      id: 'sc1',
      time: '07:30 AM',
      busId: 'b1',
      routeId: 'r1',
      period: SchedulePeriod.morning,
      status: 'On Time',
    ),
    ScheduleModel(
      id: 'sc2',
      time: '08:30 AM',
      busId: 'b2',
      routeId: 'r2',
      period: SchedulePeriod.morning,
      status: 'Delayed 5 min',
    ),
    ScheduleModel(
      id: 'sc3',
      time: '10:00 AM',
      busId: 'b3',
      routeId: 'r3',
      period: SchedulePeriod.morning,
      status: 'On Time',
    ),
    ScheduleModel(
      id: 'sc4',
      time: '01:30 PM',
      busId: 'b1',
      routeId: 'r1',
      period: SchedulePeriod.afternoon,
      status: 'Scheduled',
    ),
    ScheduleModel(
      id: 'sc5',
      time: '03:30 PM',
      busId: 'b2',
      routeId: 'r2',
      period: SchedulePeriod.afternoon,
      status: 'Scheduled',
    ),
    ScheduleModel(
      id: 'sc6',
      time: '06:00 PM',
      busId: 'b3',
      routeId: 'r3',
      period: SchedulePeriod.evening,
      status: 'Scheduled',
    ),
  ];

  static const List<AnnouncementModel> announcements = <AnnouncementModel>[
    AnnouncementModel(
      id: 'a1',
      title: 'Early departure tomorrow',
      message: "Tomorrow's first bus leaves at 7:00 AM.",
      dateLabel: 'Today',
      priority: AnnouncementPriority.important,
    ),
    AnnouncementModel(
      id: 'a2',
      title: 'Traffic delay',
      message: 'Bus 02 is delayed because of traffic near Pabna Town.',
      dateLabel: '20 min ago',
      priority: AnnouncementPriority.urgent,
    ),
    AnnouncementModel(
      id: 'a3',
      title: 'Friday service',
      message: 'Friday transportation service will run on a limited schedule.',
      dateLabel: 'Yesterday',
      priority: AnnouncementPriority.normal,
    ),
  ];

  static RouteModel routeById(String id) =>
      routes.firstWhere((route) => route.id == id);

  static DriverModel driverById(String id) =>
      drivers.firstWhere((driver) => driver.id == id);

  static BusStopModel stopById(String id) =>
      stops.firstWhere((stop) => stop.id == id);

  static BusModel? busById(List<BusModel> buses, String id) {
    for (final bus in buses) {
      if (bus.id == id) return bus;
    }
    return null;
  }
}
