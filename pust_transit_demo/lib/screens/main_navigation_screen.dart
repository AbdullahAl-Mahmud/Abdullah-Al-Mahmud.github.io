import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const _screens = <Widget>[
    HomeScreen(),
    MapScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;

    final content = IndexedStack(index: index, children: _screens);

    if (!isDesktop) {
      return Scaffold(
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: ref.read(navigationIndexProvider.notifier).setIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Map'),
            NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'Schedule'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      );
    }

    final extended = width >= 1320;
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            right: false,
            child: NavigationRail(
              extended: extended,
              minExtendedWidth: 240,
              selectedIndex: index,
              onDestinationSelected: ref.read(navigationIndexProvider.notifier).setIndex,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 32),
                child: AppLogo(showText: extended),
              ),
              groupAlignment: -0.72,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: Text('Live Map')),
                NavigationRailDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: Text('Schedule')),
                NavigationRailDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: Text('Profile')),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}
