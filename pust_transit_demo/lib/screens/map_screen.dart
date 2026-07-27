import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bus_model.dart';
import '../providers/bus_tracking_provider.dart';
import '../providers/navigation_provider.dart';
import '../services/mock_data_service.dart';
import '../utils/app_constants.dart';
import '../widgets/bus_status_card.dart';
import '../widgets/section_header.dart';
import '../widgets/transit_map.dart';
import 'bus_details_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String? _selectedBusId;

  @override
  Widget build(BuildContext context) {
    final buses = ref.watch(busTrackingProvider);
    final selectedRoute = ref.watch(selectedRouteProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;
    final visibleBuses = selectedRoute == null
        ? buses
        : buses.where((bus) => bus.routeId == selectedRoute).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Live bus tracking',
                  subtitle: 'Select a route or tap a bus marker for details',
                ),
                const SizedBox(height: 14),
                _RouteFilters(selectedRoute: selectedRoute),
                const SizedBox(height: 16),
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 7,
                              child: TransitMap(
                                height: double.infinity,
                                selectedBusId: _selectedBusId,
                                selectedRouteId: selectedRoute,
                                onBusTap: _selectBus,
                              ),
                            ),
                            const SizedBox(width: 18),
                            SizedBox(
                              width: 360,
                              child: _BusSidePanel(
                                buses: visibleBuses,
                                selectedBusId: _selectedBusId,
                                onSelect: _selectBus,
                                onOpen: _openBus,
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              TransitMap(
                                height: 430,
                                selectedBusId: _selectedBusId,
                                selectedRouteId: selectedRoute,
                                onBusTap: _selectBus,
                              ),
                              const SizedBox(height: 18),
                              for (final bus in visibleBuses) ...[
                                BusStatusCard(
                                  bus: bus,
                                  route: MockDataService.routeById(bus.routeId),
                                  compact: true,
                                  onTap: () => _openBus(bus),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectBus(BusModel bus) {
    setState(() => _selectedBusId = bus.id);
  }

  void _openBus(BusModel bus) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BusDetailsScreen(busId: bus.id),
      ),
    );
  }
}

class _RouteFilters extends ConsumerWidget {
  const _RouteFilters({required this.selectedRoute});

  final String? selectedRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            selected: selectedRoute == null,
            label: const Text('All routes'),
            avatar: const Icon(Icons.route_rounded, size: 18),
            onSelected: (_) => ref.read(selectedRouteProvider.notifier).select(null),
          ),
          const SizedBox(width: 8),
          for (final route in MockDataService.routes) ...[
            FilterChip(
              selected: selectedRoute == route.id,
              label: Text(route.destination),
              onSelected: (_) => ref.read(selectedRouteProvider.notifier).select(route.id),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _BusSidePanel extends StatelessWidget {
  const _BusSidePanel({
    required this.buses,
    required this.selectedBusId,
    required this.onSelect,
    required this.onOpen,
  });

  final List<BusModel> buses;
  final String? selectedBusId;
  final ValueChanged<BusModel> onSelect;
  final ValueChanged<BusModel> onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 14),
            child: Text('Buses in service', style: Theme.of(context).textTheme.titleLarge),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: buses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final bus = buses[index];
                final selected = selectedBusId == bus.id;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: selected ? Border.all(color: scheme.primary, width: 2) : null,
                  ),
                  child: BusStatusCard(
                    bus: bus,
                    route: MockDataService.routeById(bus.routeId),
                    compact: true,
                    onTap: () {
                      if (selected) {
                        onOpen(bus);
                      } else {
                        onSelect(bus);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tip: select a bus, then tap it again to open full details.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
