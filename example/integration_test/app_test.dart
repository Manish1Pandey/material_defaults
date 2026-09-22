// Runs the real example app on a device/desktop, walks the gallery and the
// custom-widget screen in light and dark, saves in-app screenshots (via
// RepaintBoundary.toImage) and checks that widgets built from
// MaterialDefaults render pixel-identical to the stock widgets.
//
//   flutter test integration_test -d macos
//
// Screenshots are written to `<system temp>/material_defaults_shots/` or to
// `--dart-define=SHOT_DIR=<dir>`; each path is printed.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_defaults_example/main.dart';

final GlobalKey _root = GlobalKey();

/// Where screenshots go; `--dart-define=SHOT_DIR=<dir>` overrides the app's
/// temp directory (which `flutter test` deletes with the app on iOS). On the
/// iOS simulator the app can write to a host path.
const String _shotDir = String.fromEnvironment('SHOT_DIR');

Future<ui.Image> _image(WidgetTester tester, Finder finder) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(finder);
  return boundary.toImage(pixelRatio: tester.view.devicePixelRatio);
}

Future<void> _shot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  final image = await _image(tester, find.byKey(_root));
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  final dir = Directory(
    _shotDir.isEmpty
        ? '${Directory.systemTemp.path}/material_defaults_shots'
        : _shotDir,
  )..createSync(recursive: true);
  final file = File('${dir.path}/$name.png')
    ..writeAsBytesSync(png!.buffer.asUint8List());
  debugPrint('SCREENSHOT ${file.path} (${image.width}x${image.height})');
  image.dispose();
}

Future<Uint8List> _rgba(WidgetTester tester, String key) async {
  final image = await _image(tester, find.byKey(ValueKey<String>(key)));
  final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  image.dispose();
  return bytes!.buffer.asUint8List();
}

Future<void> _walkGallery(WidgetTester tester) async {
  final list = find.byType(Scrollable).first;
  for (final entry in entries) {
    final title = find.text(entry.name);
    await tester.scrollUntilVisible(title, 150, scrollable: list);
    await tester.tap(title);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: entry.name);
    await tester.tap(title);
    await tester.pumpAndSettle();
  }
  await tester.scrollUntilVisible(
    find.textContaining('Tokens from Flutter'),
    -300,
    scrollable: list,
  );
  await tester.pumpAndSettle();
}

Future<void> _expand(WidgetTester tester, String name) async {
  final list = find.byType(Scrollable).first;
  await tester.scrollUntilVisible(find.text(name), 150, scrollable: list);
  await tester.tap(find.text(name));
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('gallery and custom widgets in light and dark', (tester) async {
    await tester.pumpWidget(
      RepaintBoundary(key: _root, child: const DefaultsGalleryApp()),
    );
    await tester.pumpAndSettle();

    for (final mode in <String>['light', 'dark']) {
      if (mode == 'dark') {
        await tester.tap(find.byTooltip('Toggle brightness'));
        await tester.pumpAndSettle();
      }
      // Gallery: open every entry once, then photograph a couple expanded.
      await _walkGallery(tester);
      await _shot(tester, 'gallery_top_$mode');
      await _expand(tester, 'FilledButton');
      await _shot(tester, 'gallery_filled_button_$mode');
      await tester.tap(find.text('FilledButton'));
      await tester.pumpAndSettle();
      await _expand(tester, 'InputDecoration');
      await _shot(tester, 'gallery_input_decoration_$mode');
      await tester.tap(find.text('InputDecoration'));
      await tester.pumpAndSettle();

      // Custom widgets: pixel-identical to the stock ones.
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();
      await _shot(tester, 'custom_$mode');
      for (final name in <String>[
        'filledButton',
        'filledButton (disabled)',
        'card',
        'divider',
      ]) {
        final stock = await _rgba(tester, '$name/stock');
        final custom = await _rgba(tester, '$name/custom');
        expect(
          tester.getSize(find.byKey(ValueKey<String>('$name/custom'))),
          tester.getSize(find.byKey(ValueKey<String>('$name/stock'))),
          reason: '$name size ($mode)',
        );
        expect(
          listEquals(stock, custom),
          isTrue,
          reason: '$name pixels ($mode)',
        );
        debugPrint('PIXEL-IDENTICAL $name ($mode, ${stock.length ~/ 4} px)');
      }
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
    }
  });
}
