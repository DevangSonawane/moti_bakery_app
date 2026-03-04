import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moti_bakery_app/main.dart';

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MotiBakeryApp()));

    expect(find.text('MOTIBAKERY'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
