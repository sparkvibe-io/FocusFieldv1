import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/screens/home_page.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
  // Allow async providers (SharedPreferences, storage) to resolve
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Silence Score App', () {
    testWidgets('should display app title', (WidgetTester tester) async {
      await _pumpApp(tester);

      expect(find.text('Silence Score'), findsOneWidget);
    });

    testWidgets('should display start control (play icon)', (WidgetTester tester) async {
      await _pumpApp(tester);

      // ProgressRing shows a play arrow icon when not listening
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('should not show status message before interaction', (WidgetTester tester) async {
      await _pumpApp(tester);

      // Status message area is empty SizedBox initially
      expect(find.text(AppConstants.successMessage), findsNothing);
      expect(find.text(AppConstants.failureMessage), findsNothing);
    });

    testWidgets('should display practice overview stats', (WidgetTester tester) async {
      await _pumpApp(tester);

      expect(find.text('Practice Overview'), findsOneWidget);
      expect(find.text('Points'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
    });

    testWidgets('should show settings button', (WidgetTester tester) async {
      await _pumpApp(tester);

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should display settings sheet when settings button is pressed', (WidgetTester tester) async {
      await _pumpApp(tester);

      await tester.tap(find.byIcon(Icons.settings));
      // Allow bottom sheet animation
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Decibel Threshold'), findsOneWidget);
      expect(find.text('Reset All Data'), findsOneWidget);
    });
  });
} 