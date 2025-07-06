import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/screens/home_page.dart';

void main() {
  group('Silence Score App', () {
    testWidgets('should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.text('Silence Score'), findsOneWidget);
    });

    testWidgets('should display start button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('should display welcome message for new users', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.text('Press Start to begin your silence journey!'), findsOneWidget);
    });

    testWidgets('should display score card with initial values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.text('Total Points'), findsOneWidget);
      expect(find.text('Current Streak'), findsOneWidget);
      expect(find.text('Best Streak'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(3)); // All scores start at 0
    });

    testWidgets('should show settings button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should display settings sheet when settings button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Decibel Threshold'), findsOneWidget);
      expect(find.text('Reset All Data'), findsOneWidget);
    });
  });
} 