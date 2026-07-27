import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement_model.dart';
import '../models/bus_model.dart';
import '../providers/bus_tracking_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/date_time_utils.dart';
import '../widgets/announcement_card.dart';
import '../widgets/bus_status_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/schedule_item.dart';
import '../widgets/section_header.dart';
import '../widgets/transit_map.dart';
import 'bus_details_screen.dart';
import 'emergency_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buses = ref.watch(busTrackingProvider);
    final query = ref.watch(searchQueryProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppConstants.mobileBreakpoint;
    final isDesktop = width >= AppConstants.desktopBreakpoint;
    final filteredBuses = buses.where((bus) {
      if (query.isEmpty) return true;
      final route = MockDataService.routeById(bus.routeId);
      return bus.name.toLowerCase().contains(query) ||
          route.name.toLowerCase().contains(query) ||
          route.destination.toLowerCase().contains(query);
    }).toList();
    final nextBus = buses.reduce(
      (current, next) =>
          current.etaMinutes <= next.etaMinutes ? current : next,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 28,
          isMobile ? 16 : 24,
          isMobile ? 16 : 28,
          34,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(isMobile: isMobile),
                const SizedBox(height: 24),
                TextField(
                  onChanged: ref.read(searchQueryProvider.notifier).update,
                  decoration: InputDecoration(
                    hintText: 'Search buses, routes, or destinations',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              ref.read(searchQueryProvider.notifier).update('');
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Quick actions',
                  subtitle: 'Everything you need for today’s journey',
                ),
                const SizedBox(height: 14),
                _QuickActions(
                  isDesktop: isDesktop,
                  onTrack: () => ref
                      .read(navigationIndexProvider.notifier)
                      .setIndex(1),
                  onSchedule: () => ref
                      .read(navigationIndexProvider.notifier)
                      .setIndex(2),
                  onEmergency: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmergencyScreen(),
                    ),
                  ),
                  onAnnouncements: () =>
                      _showAnnouncements(context, MockDataService.announcements),
                ),
                const SizedBox(height: 30),
                _NextBusHero(
                  bus: nextBus,
                  onTrack: () => _openBus(context, nextBus.id),
                ),
                const SizedBox(height: 30),
                SectionHeader(
                  title: 'Live campus map',
                  subtitle: 'Simulated positions refresh every two seconds',
                  actionLabel: 'Open full map',
                  onAction: () => ref
                      .read(navigationIndexProvider.notifier)
                      .setIndex(1),
                ),
                const SizedBox(height: 14),
                TransitMap(
                  height: isMobile ? 360 : 470,
                  onBusTap: (bus) => _openBus(context, bus.id),
                ),
                const SizedBox(height: 30),
                SectionHeader(
                  title: 'Active buses',
                  subtitle: query.isEmpty
                      ? '${buses.length} buses currently in service'
                      : '${filteredBuses.length} matching results',
                ),
                const SizedBox(height: 14),
                if (filteredBuses.isEmpty)
                  const _EmptySearch()
                else
                  _BusGrid(
                    buses: filteredBuses,
                    onTap: (bus) => _openBus(context, bus.id),
                  ),
                const SizedBox(height: 30),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _SchedulePreview(onViewAll: () => ref.read(navigationIndexProvider.notifier).setIndex(2))),
                      const SizedBox(width: 20),
                      const Expanded(child: _AnnouncementsPreview()),
                    ],
                  )
                else ...[
                  _SchedulePreview(
                    onViewAll: () => ref
                        .read(navigationIndexProvider.notifier)
                        .setIndex(2),
                  ),
                  const SizedBox(height: 20),
                  const _AnnouncementsPreview(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBus(BuildContext context, String busId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BusDetailsScreen(busId: busId),
      ),
    );
  }

  void _showAnnouncements(
    BuildContext context,
    List<AnnouncementModel> announcements,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Announcements', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                for (final item in announcements) ...[
                  AnnouncementCard(announcement: item),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final greeting = DateTime.now().hour < 12
        ? 'Good morning'
        : DateTime.now().hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Abdullah',
                style: (isMobile
                        ? Theme.of(context).textTheme.headlineSmall
                        : Theme.of(context).textTheme.headlineMedium)
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 7),
              Text(
                DateTimeUtils.fullDate(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _HeaderPill(
                    icon: Icons.location_on_outlined,
                    text: 'PUST, Pabna',
                    color: scheme.primary,
                  ),
                  const _HeaderPill(
                    icon: Icons.wb_sunny_outlined,
                    text: '29°C · Demo',
                    color: AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: themeMode == ThemeMode.dark ? 'Use light theme' : 'Use dark theme',
          onPressed: ref.read(themeModeProvider.notifier).toggle,
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Notifications',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No new critical alerts.')),
          ),
          icon: const Badge(
            smallSize: 8,
            child: Icon(Icons.notifications_none_rounded),
          ),
        ),
      ],
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.isDesktop,
    required this.onTrack,
    required this.onSchedule,
    required this.onEmergency,
    required this.onAnnouncements,
  });

  final bool isDesktop;
  final VoidCallback onTrack;
  final VoidCallback onSchedule;
  final VoidCallback onEmergency;
  final VoidCallback onAnnouncements;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: isDesktop ? 1.65 : 1.25,
          children: [
            QuickActionCard(icon: Icons.near_me_rounded, label: 'Track Bus', subtitle: 'Live locations', color: AppColors.primary, onTap: onTrack),
            QuickActionCard(icon: Icons.calendar_month_rounded, label: 'Schedule', subtitle: 'Today’s trips', color: AppColors.accent, onTap: onSchedule),
            QuickActionCard(icon: Icons.emergency_rounded, label: 'Emergency', subtitle: 'Important contacts', color: AppColors.error, onTap: onEmergency),
            QuickActionCard(icon: Icons.campaign_rounded, label: 'Announcements', subtitle: 'Service notices', color: AppColors.warning, onTap: onAnnouncements),
          ],
        );
      },
    );
  }
}

class _NextBusHero extends StatelessWidget {
  const _NextBusHero({required this.bus, required this.onTrack});

  final BusModel bus;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    final route = MockDataService.routeById(bus.routeId);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF08714B), Color(0xFF138A5B), Color(0xFF2374E1)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NEXT ARRIVING BUS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              const SizedBox(height: 10),
              Text(bus.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              Text(route.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: .9))),
              const SizedBox(height: 18),
              Wrap(
                spacing: 18,
                runSpacing: 10,
                children: [
                  _HeroMetric(icon: Icons.schedule_rounded, text: '${bus.etaMinutes} min ETA'),
                  _HeroMetric(icon: Icons.location_on_rounded, text: bus.nextStop),
                  _HeroMetric(icon: Icons.event_seat_rounded, text: '${bus.seatsAvailable} seats'),
                ],
              ),
            ],
          );
          final action = FilledButton.icon(
            onPressed: onTrack,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: scheme.primary,
            ),
            icon: const Icon(Icons.near_me_rounded),
            label: const Text('Track now'),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [details, const SizedBox(height: 22), action],
            );
          }
          return Row(
            children: [Expanded(child: details), const SizedBox(width: 20), action],
          );
        },
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 19),
        const SizedBox(width: 7),
        Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _BusGrid extends StatelessWidget {
  const _BusGrid({required this.buses, required this.onTap});

  final List<BusModel> buses;
  final ValueChanged<BusModel> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1150
            ? 3
            : constraints.maxWidth >= 720
                ? 2
                : 1;
        final itemWidth = (constraints.maxWidth - (20 * (columns - 1))) / columns;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final bus in buses)
              SizedBox(
                width: itemWidth,
                child: BusStatusCard(
                  bus: bus,
                  route: MockDataService.routeById(bus.routeId),
                  onTap: () => onTap(bus),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          SectionHeader(title: 'Today’s schedule', actionLabel: 'View all', onAction: onViewAll),
          const SizedBox(height: 16),
          for (final schedule in MockDataService.schedules.take(3)) ...[
            ScheduleItem(schedule: schedule),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementsPreview extends StatelessWidget {
  const _AnnouncementsPreview();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Announcements', subtitle: 'Latest transport notices'),
          const SizedBox(height: 16),
          for (final item in MockDataService.announcements.take(3)) ...[
            AnnouncementCard(announcement: item),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text('No matching buses found', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
