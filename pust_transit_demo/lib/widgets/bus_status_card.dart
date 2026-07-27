import 'package:flutter/material.dart';

import '../models/bus_model.dart';
import '../models/route_model.dart';
import 'glass_card.dart';
import 'status_badge.dart';

class BusStatusCard extends StatelessWidget {
  const BusStatusCard({
    super.key,
    required this.bus,
    required this.route,
    required this.onTap,
    this.compact = false,
  });

  final BusModel bus;
  final RouteModel route;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.all(compact ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.directions_bus_filled_rounded,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bus.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      route.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: bus.status),
            ],
          ),
          SizedBox(height: compact ? 14 : 20),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              _Metric(icon: Icons.schedule_rounded, value: '${bus.etaMinutes} min', label: 'ETA'),
              _Metric(icon: Icons.airline_seat_recline_normal_rounded, value: '${bus.seatsAvailable}', label: 'Seats'),
              _Metric(icon: Icons.speed_rounded, value: '${bus.currentSpeed.round()} km/h', label: 'Speed'),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 18),
            Divider(color: scheme.outlineVariant.withValues(alpha: .6)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Next: ${bus.nextStop}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}
