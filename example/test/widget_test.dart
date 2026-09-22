import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';
import 'package:material_defaults_example/main.dart';
import 'package:material_defaults_example/properties.dart';

void main() {
  testWidgets('gallery lists every component and expands one', (tester) async {
    await tester.pumpWidget(const DefaultsGalleryApp());
    expect(find.textContaining(MaterialDefaults.tokenVersion), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('InputDecoration'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('InputDecoration'));
    await tester.pumpAndSettle();
    expect(find.text('hintStyle'), findsOneWidget);
    expect(entries, hasLength(56));
  });

  testWidgets('every gallery entry renders in light and dark, wide and phone', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    for (final (brightness, size) in <(Brightness, Size)>[
      (Brightness.light, const Size(800, 600)),
      (Brightness.dark, const Size(800, 600)),
      (Brightness.light, const Size(360, 740)),
      (Brightness.dark, const Size(360, 740)),
    ]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seeds.first,
              brightness: brightness,
            ),
          ),
          home: Scaffold(
            body: ListView(
              key: ValueKey<String>('$brightness$size'),
              children: <Widget>[
                for (final e in entries)
                  DefaultsTile(key: ValueKey<String>(e.name), entry: e),
              ],
            ),
          ),
        ),
      );
      for (final e in entries) {
        final title = find.text(e.name);
        await tester.scrollUntilVisible(title, 200);
        await tester.tap(title);
        await tester.pumpAndSettle();
        await tester.tap(title);
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('custom widgets match the stock ones', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 740);
    await tester.pumpWidget(const DefaultsGalleryApp());
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();
    for (final name in <String>['filledButton', 'card', 'divider']) {
      final stock = tester.getSize(find.byKey(ValueKey<String>('$name/stock')));
      final custom = tester.getSize(
        find.byKey(ValueKey<String>('$name/custom')),
      );
      expect(custom, stock, reason: name);
    }
    final context = tester.element(find.byType(DefaultsPillButton).first);
    final scheme = Theme.of(context).colorScheme;
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(DefaultsPillButton).first,
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.color, scheme.primary);
    expect(material.shape, const StadiumBorder());
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: DefaultsPillButton(
              onPressed: () => tapped = true,
              label: 'Pill',
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Pill'));
    expect(tapped, isTrue);
  });

  testWidgets('the gallery reads every diagnostics property explicitly', (
    tester,
  ) async {
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
    // Diagnostics labels that differ from the getter name.
    const renamed = <String, String>{
      'checkMarkColor': 'checkmarkColor',
      'weekDayStyle': 'weekdayStyle',
      'text style': 'textStyle',
    };
    for (final e in entries) {
      final value = e.read(d);
      final (type, props) = propertiesOf(value)!;
      expect(type, value.runtimeType.toString());
      final diagnostics = (value as Diagnosticable)
          .toDiagnosticsNode()
          .getProperties();
      for (final node in diagnostics) {
        final name = renamed[node.name] ?? node.name!;
        if (name == 'year2023') {
          continue;
        }
        expect(props.containsKey(name), isTrue, reason: '${e.name}.$name');
        expect(props[name], same(node.value), reason: '${e.name}.$name');
      }
    }
  });
}
