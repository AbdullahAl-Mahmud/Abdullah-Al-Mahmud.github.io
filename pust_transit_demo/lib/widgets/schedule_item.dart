import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../services/mock_data_service.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({super.key, required this.schedule, this.showPeriod = false});

  final ScheduleModel schedule;
  final bool showPeriod;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final route = MockDataService.routeById(schedule.routeId);
    final bus = MockDataService.initialBuses().firstWhere((item) => item.id == schedule.busId);
    final delayed = schedule.status.toLowerCase().contains('delay');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .55)),
      ),
      child: Row(
        children: [
          Container(
            width: 78,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(schedule.time, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
                if (showPeriod) ...[
                  const SizedBox(height: 3),
                  Text(schedule.period.label, style: Theme.of(context).textTheme.labelSmall),
                ],
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${bus.name} · ${route.destination}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text('${route.origin} → ${route.destination}', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: (delayed ? scheme.error : scheme.primary).withValues(alpha: .1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              schedule.status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: delayed ? scheme.error : scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
