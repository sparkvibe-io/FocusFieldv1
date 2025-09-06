
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/l10n/app_localizations.dart';
import 'package:silence_score/services/tip_service.dart';
import 'package:silence_score/widgets/tip_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget _appWithScaffold({required Widget child}) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('toggle persistence survives new service instance', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final service = container.read(tipServiceProvider);
    await service.setEnabled(false);
    expect(await service.getEnabled(), isFalse);

    final container2 = ProviderContainer();
    addTearDown(container2.dispose);
    final service2 = container2.read(tipServiceProvider);
    expect(await service2.getEnabled(), isFalse);
  });

  testWidgets('manual tip display: shows tip when requested', (tester) async {
    BuildContext? ctx;
    await tester.pumpWidget(_appWithScaffold(
      child: Builder(builder: (c) {
        ctx = c;
        return const SizedBox.shrink();
      }),
    ));

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final service = container.read(tipServiceProvider);

    await service.setEnabled(true);

    // First manual tip request should show a tip
    await service.showCurrentTip(ctx!);
    await tester.pump(const Duration(milliseconds: 50));

    // First overlay should be present with a TipOverlay widget
    expect(find.byType(Overlay), findsWidgets);
    expect(find.byType(TipOverlay), findsOneWidget);

    // Second attempt in same session should not show another tip
    await service.showCurrentTip(ctx!);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(TipOverlay), findsOneWidget);
    
    // Let auto-dismiss timer complete to avoid pending timers
    await tester.pump(const Duration(seconds: 11));
  });

  testWidgets('lightbulb allows unlimited tip viewing', (tester) async {
    BuildContext? ctx;
    await tester.pumpWidget(_appWithScaffold(
      child: Builder(builder: (c) {
        ctx = c;
        return const SizedBox.shrink();
      }),
    ));

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final service = container.read(tipServiceProvider);

    await service.setEnabled(true);

    // First manual tip request should show a tip
    await service.showCurrentTip(ctx!);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(TipOverlay), findsOneWidget);

    // Close the tip by tapping the close icon
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 50));

    // Wait for any pending timers to complete
    await tester.pump(const Duration(seconds: 11));

    // Second attempt should show another tip (no session restrictions)
    await service.showCurrentTip(ctx!);
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(TipOverlay), findsOneWidget);
    
    // Wait for any pending timers to complete
    await tester.pump(const Duration(seconds: 11));
  });
}
