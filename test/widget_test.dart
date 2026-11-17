import 'package:flutter_test/flutter_test.dart';
import 'package:helpnear/main.dart';

void main() {
  testWidgets('HelpNear app displays the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HelpNearApp());

    expect(find.text('HelpNear'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
  });
}
