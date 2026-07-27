import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../services/mock_data_service.dart';
import '../utils/app_constants.dart';
import '../widgets/glass_card.dart';
import '../widgets/schedule_item.dart';
import '../widgets/section_header.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? _routeId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppConstants.mobileBreakpoint;
    final schedules = _routeId == null
        ? MockDataService.schedules
        : MockDataService.schedules
            .where((schedule) => schedule.routeId == _routeId)
            .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Bus schedule',
                  subtitle: 'Plan your campus journey by time and destination',
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _routeId == null,
                        label: const Text('All'),
                        onSelected: (_) => setState(() => _routeId = null),
                      ),
                      const SizedBox(width: 8),
                      for (final route in MockDataService.routes) ...[
                        FilterChip(
                          selected: _routeId == route.id,
                          label: Text(route.destination),
                          onSelected: (_) => setState(() => _routeId = route.id),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                for (final period in SchedulePeriod.values) ...[
                  _ScheduleGroup(
                    period: period,
                    schedules: schedules
                        .where((schedule) => schedule.period == period)
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                ],
                GlassCard(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .55),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This MVP uses demonstration schedules. Confirm official departure times with the PUST Transport Office.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleGroup extends StatelessWidget {
  const _ScheduleGroup({required this.period, required this.schedules});

  final SchedulePeriod period;
  final List<ScheduleModel> schedules;

  @override
  Widget build(BuildContext context) {
    final icon = switch (period) {
      SchedulePeriod.morning => Icons.wb_sunny_outlined,
      SchedulePeriod.afternoon => Icons.light_mode_outlined,
      SchedulePeriod.evening => Icons.nights_stay_outlined,
    };
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Text(period.label, style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('${schedules.length} trips', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 16),
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Center(
                child: Text(
                  'No trips for this filter',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            for (final schedule in schedules) ...[
              ScheduleItem(schedule: schedule, showPeriod: false),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}
