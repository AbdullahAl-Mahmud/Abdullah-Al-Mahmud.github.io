import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pust_transit/app.dart';

void main() {
  testWidgets('shows PUST Transit splash content', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PustTransitApp()));

    expect(find.text('PUST Transit'), findsOneWidget);
    expect(
      find.text('Smart Campus Transportation, Connected in Real Time.'),
      findsOneWidget,
    );
  });
}
