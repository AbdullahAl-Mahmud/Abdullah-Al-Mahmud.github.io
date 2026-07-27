import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bus_model.dart';
import '../providers/bus_tracking_provider.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';

class TransitMap extends ConsumerStatefulWidget {
  const TransitMap({
    super.key,
    this.height = 430,
    this.selectedBusId,
    this.selectedRouteId,
    this.onBusTap,
    this.borderRadius = 26,
  });

  final double height;
  final String? selectedBusId;
  final String? selectedRouteId;
  final ValueChanged<BusModel>? onBusTap;
  final double borderRadius;

  @override
  ConsumerState<TransitMap> createState() => _TransitMapState();
}

class _TransitMapState extends ConsumerState<TransitMap> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final buses = ref.watch(busTrackingProvider);
    final scheme = Theme.of(context).colorScheme;
    final routes = widget.selectedRouteId == null
        ? MockDataService.routes
        : MockDataService.routes
            .where((route) => route.id == widget.selectedRouteId)
            .toList();

    final map = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: AppConstants.campusCenter,
                initialZoom: 13.8,
                minZoom: 7,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: AppConstants.tileUrl,
                  userAgentPackageName: 'com.pust.transit',
                  maxNativeZoom: 19,
                ),
                PolylineLayer(
                  polylines: [
                    for (final route in routes)
                      Polyline(
                        points: route.path,
                        strokeWidth: widget.selectedRouteId == route.id ? 6 : 4,
                        color: _routeColor(route.id).withValues(alpha: .88),
                      ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for (final stop in MockDataService.stops)
                      Marker(
                        point: stop.position,
                        width: 18,
                        height: 18,
                        child: Tooltip(
                          message: stop.name,
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: scheme.primary, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .16),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Marker(
                      point: AppConstants.studentPosition,
                      width: 44,
                      height: 44,
                      child: _MapPin(
                        tooltip: 'Your demo location',
                        color: AppColors.accent,
                        icon: Icons.person_rounded,
                      ),
                    ),
                    for (final bus in buses)
                      Marker(
                        point: bus.position,
                        width: widget.selectedBusId == bus.id ? 58 : 50,
                        height: widget.selectedBusId == bus.id ? 58 : 50,
                        child: GestureDetector(
                          onTap: () => widget.onBusTap?.call(bus),
                          child: _BusMarker(
                            bus: bus,
                            selected: widget.selectedBusId == bus.id,
                            color: _routeColor(bus.routeId),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Column(
                children: [
                  _MapButton(
                    tooltip: 'Recenter campus',
                    icon: Icons.my_location_rounded,
                    onTap: () => _mapController.move(AppConstants.campusCenter, 13.8),
                  ),
                  const SizedBox(height: 8),
                  _MapButton(
                    tooltip: 'Zoom in',
                    icon: Icons.add_rounded,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MapButton(
                    tooltip: 'Zoom out',
                    icon: Icons.remove_rounded,
                    onTap: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 12,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  AppConstants.osmAttribution,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.height.isInfinite) {
      return SizedBox.expand(child: map);
    }
    return SizedBox(height: widget.height, child: map);
  }

  Color _routeColor(String routeId) => switch (routeId) {
        'r1' => AppColors.primary,
        'r2' => AppColors.accent,
        'r3' => AppColors.warning,
        _ => AppColors.primary,
      };
}

class _BusMarker extends StatelessWidget {
  const _BusMarker({required this.bus, required this.selected, required this.color});

  final BusModel bus;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${bus.name} · ETA ${bus.etaMinutes} min',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: selected ? 4 : 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .38),
              blurRadius: selected ? 18 : 12,
              spreadRadius: selected ? 3 : 1,
            ),
          ],
        ),
        child: const Icon(Icons.directions_bus_filled_rounded, color: Colors.white),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.tooltip, required this.color, required this.icon});

  final String tooltip;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: .3), blurRadius: 12),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.tooltip, required this.icon, required this.onTap});

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: scheme.surface.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(13),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(width: 42, height: 42, child: Icon(icon, size: 21)),
        ),
      ),
    );
  }
}
