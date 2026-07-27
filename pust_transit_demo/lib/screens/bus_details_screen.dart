import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bus_model.dart';
import '../providers/bus_tracking_provider.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/date_time_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/transit_map.dart';
import 'emergency_screen.dart';

class BusDetailsScreen extends ConsumerWidget {
  const BusDetailsScreen({super.key, required this.busId});

  final String busId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buses = ref.watch(busTrackingProvider);
    final bus = MockDataService.busById(buses, busId);
    if (bus == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bus details')),
        body: const Center(child: Text('Bus not found.')),
      );
    }

    final route = MockDataService.routeById(bus.routeId);
    final driver = MockDataService.driverById(bus.driverId);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;
    final progress = ((bus.pathIndex + bus.segmentProgress) /
            (route.path.length - 1))
        .clamp(0.0, 1.0)
        .toDouble();

    final map = TransitMap(
      height: isDesktop ? 620 : 430,
      selectedBusId: bus.id,
      selectedRouteId: bus.routeId,
    );
    final information = Column(
      children: [
        _BusSummary(bus: bus),
        const SizedBox(height: 16),
        _RouteProgress(bus: bus, progress: progress),
        const SizedBox(height: 16),
        _DriverCard(driverName: driver.name, driverPhone: driver.phone, experience: driver.experienceYears),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const EmergencyScreen()),
            ),
            icon: const Icon(Icons.emergency_rounded),
            label: const Text('Emergency contacts'),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(bus.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(child: StatusBadge(status: bus.status)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailsHero(bus: bus),
                  const SizedBox(height: 20),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: map),
                        const SizedBox(width: 20),
                        SizedBox(width: 390, child: information),
                      ],
                    )
                  else ...[
                    map,
                    const SizedBox(height: 16),
                    information,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsHero extends StatelessWidget {
  const _DetailsHero({required this.bus});

  final BusModel bus;

  @override
  Widget build(BuildContext context) {
    final route = MockDataService.routeById(bus.routeId);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF086447), AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 30,
        runSpacing: 22,
        children: [
          SizedBox(
            width: 460,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bus.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(route.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: .88))),
                const SizedBox(height: 14),
                Text('Now near ${bus.currentStop}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroStat(label: 'ETA', value: '${bus.etaMinutes} min', icon: Icons.schedule_rounded),
              _HeroStat(label: 'Speed', value: '${bus.currentSpeed.round()} km/h', icon: Icons.speed_rounded),
              _HeroStat(label: 'Seats', value: '${bus.seatsAvailable}', icon: Icons.event_seat_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _BusSummary extends StatelessWidget {
  const _BusSummary({required this.bus});

  final BusModel bus;

  @override
  Widget build(BuildContext context) {
    final route = MockDataService.routeById(bus.routeId);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Journey information', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          _InfoRow(icon: Icons.radio_button_checked_rounded, label: 'Current stop', value: bus.currentStop),
          _InfoRow(icon: Icons.location_on_rounded, label: 'Next stop', value: bus.nextStop),
          _InfoRow(icon: Icons.trip_origin_rounded, label: 'Starting point', value: route.origin),
          _InfoRow(icon: Icons.flag_rounded, label: 'Destination', value: route.destination),
          _InfoRow(icon: Icons.confirmation_number_outlined, label: 'Registration', value: bus.registration),
          _InfoRow(icon: Icons.update_rounded, label: 'Last update', value: DateTimeUtils.time(bus.lastUpdated), last: true),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.last = false});

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: .5))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: scheme.onSurfaceVariant))),
          const SizedBox(width: 10),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _RouteProgress extends StatelessWidget {
  const _RouteProgress({required this.bus, required this.progress});

  final BusModel bus;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final route = MockDataService.routeById(bus.routeId);
    final stops = route.stopIds.map(MockDataService.stopById).toList();
    final activeIndex = ((progress * stops.length).floor()).clamp(0, stops.length - 1);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Route progress', style: Theme.of(context).textTheme.titleLarge)),
              Text('${(progress * 100).round()}%', style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(value: progress, minHeight: 9, borderRadius: BorderRadius.circular(99)),
          const SizedBox(height: 18),
          for (var i = 0; i < stops.length; i++)
            _StopLine(
              name: stops[i].name,
              completed: i < activeIndex,
              active: i == activeIndex,
              last: i == stops.length - 1,
            ),
        ],
      ),
    );
  }
}

class _StopLine extends StatelessWidget {
  const _StopLine({required this.name, required this.completed, required this.active, required this.last});

  final String name;
  final bool completed;
  final bool active;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = completed || active ? scheme.primary : scheme.outlineVariant;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: active ? 16 : 12,
                height: active ? 16 : 12,
                decoration: BoxDecoration(
                  color: active ? scheme.primary : completed ? scheme.primary : scheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
              if (!last) Container(width: 2, height: 32, color: color),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(name, style: TextStyle(fontWeight: active ? FontWeight.w800 : FontWeight.w500, color: active ? scheme.primary : null)),
          ),
        ),
      ],
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driverName, required this.driverPhone, required this.experience});

  final String driverName;
  final String driverPhone;
  final int experience;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Driver information', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.person_rounded, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverName, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('$experience years experience', style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text(driverPhone, style: const TextStyle(fontWeight: FontWeight.w600))),
              IconButton.filledTonal(
                tooltip: 'Call driver',
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Demo call'),
                    content: Text('Calling is disabled on this demo. Driver number: $driverPhone'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                  ),
                ),
                icon: const Icon(Icons.call_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
