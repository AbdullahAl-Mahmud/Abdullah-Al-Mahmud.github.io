import 'package:latlong2/latlong.dart';

abstract final class AppConstants {
  static const String appName = 'PUST Transit';
  static const String tagline =
      'Smart Campus Transportation, Connected in Real Time.';
  static const LatLng campusCenter = LatLng(24.0064, 89.2493);
  static const LatLng studentPosition = LatLng(24.0058, 89.2501);
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1024;
  static const String tileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmAttribution = '© OpenStreetMap contributors';
}
