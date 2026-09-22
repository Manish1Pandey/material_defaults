import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';

import 'support/parity.dart';

void main() {
  testWidgets('values follow the ambient ColorScheme and TextTheme', (
    tester,
  ) async {
    late MaterialDefaults light;
    late MaterialDefaults dark;
    await tester.pumpWidget(
      MaterialApp(
        theme: parityThemes['light'],
        home: Row(
          children: <Widget>[
            Builder(
              builder: (context) {
                light = MaterialDefaults.of(context);
                return const SizedBox();
              },
            ),
            Theme(
              data: parityThemes['dark']!,
              child: Builder(
                builder: (context) {
                  dark = MaterialDefaults.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
    final lightScheme = parityThemes['light']!.colorScheme;
    final darkScheme = parityThemes['dark']!.colorScheme;
    expect(
      light.filledButton.backgroundColor!.resolve(<WidgetState>{}),
      lightScheme.primary,
    );
    expect(
      dark.filledButton.backgroundColor!.resolve(<WidgetState>{}),
      darkScheme.primary,
    );
    expect(
      light.filledButton.backgroundColor!.resolve(<WidgetState>{
        WidgetState.disabled,
      }),
      // The framework uses the (8-bit quantising) withOpacity.
      // ignore: deprecated_member_use
      lightScheme.onSurface.withOpacity(0.12),
    );
    expect(light.card.color, lightScheme.surfaceContainerLow);
    expect(dark.outlinedCard.shape, isA<RoundedRectangleBorder>());
    expect(light.appliesToCurrentTheme, isTrue);
  });

  testWidgets('appliesToCurrentTheme is false for Material 2 themes', (
    tester,
  ) async {
    late MaterialDefaults d;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: Builder(
          builder: (context) {
            d = MaterialDefaults.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(d.appliesToCurrentTheme, isFalse);
  });

  testWidgets('returned objects are snapshots that outlive their context', (
    tester,
  ) async {
    late ButtonStyle style;
    late InputDecorationThemeData decoration;
    await tester.pumpWidget(
      MaterialApp(
        theme: parityThemes['dark'],
        home: Builder(
          builder: (context) {
            final d = MaterialDefaults.of(context);
            style = d.elevatedButton;
            decoration = d.inputDecoration;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());
    // The element is gone; resolving must not touch it.
    final scheme = parityThemes['dark']!.colorScheme;
    for (final states in allStateSets) {
      style.backgroundColor!.resolve(states);
      style.overlayColor!.resolve(states);
    }
    expect(style.foregroundColor!.resolve(<WidgetState>{}), scheme.primary);
    expect(decoration.fillColor, isNotNull);
  });

  testWidgets('partial override keeps every other default', (tester) async {
    late ButtonStyle base;
    late ButtonStyle custom;
    await tester.pumpWidget(
      MaterialApp(
        theme: parityThemes['light'],
        home: Builder(
          builder: (context) {
            base = MaterialDefaults.of(context).filledButton;
            custom = base.copyWith(
              shape: const WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(),
              ),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    expect(
      custom.shape!.resolve(<WidgetState>{}),
      const RoundedRectangleBorder(),
    );
    for (final states in allStateSets) {
      expect(
        custom.backgroundColor!.resolve(states),
        base.backgroundColor!.resolve(states),
      );
    }
  });

  testWidgets('documented corrections match the widgets', (tester) async {
    late MaterialDefaults d;
    await tester.pumpWidget(
      MaterialApp(
        theme: parityThemes['light'],
        home: Builder(
          builder: (context) {
            d = MaterialDefaults.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    final scheme = parityThemes['light']!.colorScheme;
    expect(d.appBar.toolbarHeight, kToolbarHeight);
    expect(d.appBar.surfaceTintColor, scheme.surfaceTint);
    expect(
      WidgetStateProperty.resolveAs<Color?>(
        d.appBar.backgroundColor,
        <WidgetState>{WidgetState.scrolledUnder},
      ),
      scheme.surfaceContainer,
    );
    expect(d.banner.elevation, 0.0);
    expect(d.snackBar().shape, isNull);
    expect(d.snackBar(floating: true).shape, isNotNull);
    expect(d.snackBar(floating: true).behavior, SnackBarBehavior.floating);
  });

  test('version metadata', () {
    expect(MaterialDefaults.tokenVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
    expect(MaterialDefaults.flutterRevision, hasLength(40));
    expect(MaterialDefaults.tokenDataVersions, isNotEmpty);
    expect(MaterialDefaults.generatedBlocks, contains('FilledButton'));
  });

  testWidgets('the comparison harness detects a difference', (tester) async {
    late MaterialDefaults d;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            d = MaterialDefaults.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(
      () => expectSameDefaults(d.filledButton, d.filledTonalButton),
      throwsA(isA<TestFailure>()),
    );
    expect(
      expectSameDefaults(d.filledButton, d.filledButton),
      greaterThan(1000),
    );
  });
}
