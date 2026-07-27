import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int value) => state = value;
}

final navigationIndexProvider =
    NotifierProvider<NavigationIndexNotifier, int>(NavigationIndexNotifier.new);

class SelectedRouteNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? routeId) => state = routeId;
}

final selectedRouteProvider =
    NotifierProvider<SelectedRouteNotifier, String?>(SelectedRouteNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value.trim().toLowerCase();
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);
