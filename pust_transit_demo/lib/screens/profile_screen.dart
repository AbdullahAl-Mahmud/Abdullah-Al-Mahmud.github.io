import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _delayAlerts = true;
  bool _arrivalAlerts = true;
  String _preferredRoute = 'r1';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppConstants.mobileBreakpoint;
    final themeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Student profile',
                  subtitle: 'Demo identity and application preferences',
                ),
                const SizedBox(height: 20),
                _ProfileHero(isMobile: isMobile),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final preferences = _PreferencesCard(
                      themeMode: themeMode,
                      delayAlerts: _delayAlerts,
                      arrivalAlerts: _arrivalAlerts,
                      preferredRoute: _preferredRoute,
                      onThemeChanged: (mode) => ref.read(themeModeProvider.notifier).setMode(mode),
                      onDelayChanged: (value) => setState(() => _delayAlerts = value),
                      onArrivalChanged: (value) => setState(() => _arrivalAlerts = value),
                      onRouteChanged: (value) {
                        if (value != null) setState(() => _preferredRoute = value);
                      },
                    );
                    const about = _AboutCard();
                    if (constraints.maxWidth < 760) {
                      return Column(
                        children: [preferences, const SizedBox(height: 20), about],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: preferences),
                        const SizedBox(width: 20),
                        const Expanded(child: about),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: isMobile
          ? const Column(
              children: [
                _Avatar(),
                SizedBox(height: 16),
                _ProfileText(centered: true),
              ],
            )
          : const Row(
              children: [
                _Avatar(),
                SizedBox(width: 22),
                Expanded(child: _ProfileText()),
              ],
            ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Center(
        child: Text('AM', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _ProfileText extends StatelessWidget {
  const _ProfileText({this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text('Abdullah Al Mahmud', textAlign: centered ? TextAlign.center : TextAlign.start, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        const Text('Information and Communication Engineering', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        const Text('Pabna University of Science and Technology', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(999)),
          child: const Text('Student ID: Demo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
    required this.themeMode,
    required this.delayAlerts,
    required this.arrivalAlerts,
    required this.preferredRoute,
    required this.onThemeChanged,
    required this.onDelayChanged,
    required this.onArrivalChanged,
    required this.onRouteChanged,
  });

  final ThemeMode themeMode;
  final bool delayAlerts;
  final bool arrivalAlerts;
  final String preferredRoute;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<bool> onDelayChanged;
  final ValueChanged<bool> onArrivalChanged;
  final ValueChanged<String?> onRouteChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_rounded), label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_rounded), label: Text('Dark')),
            ],
            selected: {themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light},
            onSelectionChanged: (selection) => onThemeChanged(selection.first),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: preferredRoute,
            decoration: const InputDecoration(labelText: 'Preferred route', prefixIcon: Icon(Icons.route_rounded)),
            items: [
              for (final route in MockDataService.routes)
                DropdownMenuItem(value: route.id, child: Text(route.name)),
            ],
            onChanged: onRouteChanged,
          ),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Delay alerts'),
            subtitle: const Text('Notify when a bus is delayed'),
            value: delayAlerts,
            onChanged: onDelayChanged,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Arrival alerts'),
            subtitle: const Text('Notify before the bus reaches campus'),
            value: arrivalAlerts,
            onChanged: onArrivalChanged,
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About this demo', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          const _AboutRow(icon: Icons.verified_outlined, title: 'Version', value: 'MVP Demo 1.0.0'),
          const _AboutRow(icon: Icons.map_outlined, title: 'Map provider', value: 'OpenStreetMap'),
          const _AboutRow(icon: Icons.gps_fixed_rounded, title: 'Tracking', value: 'Simulated data'),
          const _AboutRow(icon: Icons.code_rounded, title: 'Platform', value: 'Flutter Web'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Authentication is not enabled in this demo.')),
              ),
              icon: Icon(Icons.logout_rounded, color: scheme.error),
              label: Text('Demo logout', style: TextStyle(color: scheme.error)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(value, style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
