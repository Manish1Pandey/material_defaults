// Shared equivalence harness for the material_defaults tests.
//
// Two kinds of proof are used:
//
// * Instance parity (`expectSameDefaults`): our object is compared with the
//   object the framework itself produces (obtained through a public or
//   protected framework entry point). Every diagnostics property is compared;
//   every WidgetStateProperty is resolved for all 256 combinations of the
//   eight interactive WidgetStates.
//
// * Render parity (`expectRenderParity`): a real widget scene is pumped with
//   the stock theme, then with our defaults injected as the component theme,
//   in several interaction states. Pixels and the (hash-normalised) render
//   tree must be identical. A deliberately perturbed copy must render
//   differently, proving the scene is sensitive to the injected theme.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';

/// The light and dark themes every parity test runs under. A non-baseline seed
/// makes every ColorScheme role distinct from the M3 baseline palette.
final Map<String, ThemeData> parityThemes = <String, ThemeData>{
  'light': ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00696E)),
  ),
  'dark': ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00696E),
      brightness: Brightness.dark,
    ),
  ),
};

/// Deterministic ink for pixel comparisons (InkSparkle uses a random seed).
ThemeData renderBase(ThemeData theme) =>
    theme.copyWith(splashFactory: InkRipple.splashFactory);

const List<WidgetState> _interactiveStates = <WidgetState>[
  WidgetState.hovered,
  WidgetState.focused,
  WidgetState.pressed,
  WidgetState.dragged,
  WidgetState.selected,
  WidgetState.scrolledUnder,
  WidgetState.disabled,
  WidgetState.error,
];

/// All 256 subsets of the eight interactive states.
final List<Set<WidgetState>> allStateSets = <Set<WidgetState>>[
  for (var mask = 0; mask < 1 << _interactiveStates.length; mask++)
    <WidgetState>{
      for (var i = 0; i < _interactiveStates.length; i++)
        if (mask & (1 << i) != 0) _interactiveStates[i],
    },
];

/// Names of the diagnostics properties of [value].
Map<String, Object?> diagnosticsOf(Diagnosticable value) {
  final result = <String, Object?>{};
  for (final node in value.toDiagnosticsNode().getProperties()) {
    if (node is DiagnosticsProperty && node.name != null) {
      result[node.name!] = node.value;
    }
  }
  // Properties some framework classes leave out of debugFillProperties.
  switch (value) {
    case ButtonStyle():
      result['splashFactory'] = value.splashFactory;
    case ChipThemeData():
      result['checkmarkColor'] = value.checkmarkColor;
    case DatePickerThemeData():
      result['weekdayStyle'] = value.weekdayStyle;
  }
  return result;
}

/// Compares two default objects property-by-property.
///
/// Returns the number of leaf comparisons made (so callers can assert the
/// comparison was not vacuous).
int expectSameDefaults(Object? ours, Object? theirs, {String path = ''}) {
  return _compare(ours, theirs, path.isEmpty ? '${ours.runtimeType}' : path);
}

int _compare(Object? a, Object? b, String path) {
  if (a is WidgetStateProperty<Object?> || b is WidgetStateProperty<Object?>) {
    expect(
      a is WidgetStateProperty<Object?>,
      b is WidgetStateProperty<Object?>,
      reason: '$path: only one side is a WidgetStateProperty',
    );
    var count = 0;
    for (final states in allStateSets) {
      count += _compare(
        (a! as WidgetStateProperty<Object?>).resolve(states),
        (b! as WidgetStateProperty<Object?>).resolve(states),
        '$path$states',
      );
    }
    return count;
  }
  if (a == b) {
    return 1;
  }
  if (a is Diagnosticable &&
      b is Diagnosticable &&
      a is! TextStyle &&
      a is! IconThemeData) {
    final da = diagnosticsOf(a);
    final db = diagnosticsOf(b);
    expect(
      da.keys.toSet(),
      db.keys.toSet(),
      reason: '$path: property names differ',
    );
    var count = 0;
    for (final name in da.keys) {
      count += _compare(da[name], db[name], '$path.$name');
    }
    return count;
  }
  fail('$path: $a != $b');
}

/// Parses `lib/src/generated/*.g.dart` and returns, for generated class
/// [className], every property it defines: overridden getters plus named
/// arguments passed to `super(...)`.
Set<String> generatedProperties(String className) {
  final dir = Directory('lib/src/generated');
  for (final file in dir.listSync().whereType<File>()) {
    final source = file.readAsStringSync();
    final start = source.indexOf(RegExp('class $className\\b'));
    if (start < 0) {
      continue;
    }
    final rest = source.substring(start + 1);
    final next = rest.indexOf(
      RegExp(r'^(class |// dart format on)', multiLine: true),
    );
    final body = source.substring(start, start + 1 + next);
    final names = <String>{
      for (final m in RegExp(r'\bget ([a-zA-Z]\w*)').allMatches(body))
        m.group(1)!,
    };
    final superCall = RegExp(r':\s*super\(([\s\S]*?)\);').firstMatch(body);
    if (superCall != null) {
      for (final m in RegExp(
        r'^\s*([a-zA-Z]\w*):',
        multiLine: true,
      ).allMatches(superCall.group(1)!)) {
        names.add(m.group(1)!);
      }
    }
    return names;
  }
  throw StateError('Generated class $className not found');
}

/// Asserts that every property defined by generated class [className] is
/// visible through [value]'s diagnostics, i.e. is covered by
/// [expectSameDefaults].
void expectFullCoverage(String className, Diagnosticable value) {
  final defined = generatedProperties(className);
  expect(defined, isNotEmpty);
  final visible = diagnosticsOf(value).keys.toSet();
  expect(
    defined.difference(visible),
    isEmpty,
    reason: '$className defines properties that diagnostics do not expose',
  );
}

// ------------------------------------------------------------ render parity

final List<Future<void> Function()> _cleanups = <Future<void> Function()>[];

/// A step that puts the scene into an interaction state before capture.
typedef ParityStep = Future<void> Function(WidgetTester tester);

/// Leaves the scene as pumped.
Future<void> idle(WidgetTester tester) async {}

/// Hovers a mouse over the first widget found by [finder].
ParityStep hover(Finder finder) => (WidgetTester tester) async {
  final gesture = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  _cleanups.add(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(finder.first));
  await tester.pumpAndSettle();
};

/// Moves keyboard focus forward [times] times with Tab.
ParityStep tab([int times = 1]) => (WidgetTester tester) async {
  for (var i = 0; i < times; i++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  }
  await tester.pumpAndSettle();
};

/// Presses (and holds) the first widget found by [finder].
ParityStep press(Finder finder) => (WidgetTester tester) async {
  final gesture = await tester.startGesture(tester.getCenter(finder.first));
  _cleanups.add(gesture.up);
  await tester.pump(const Duration(milliseconds: 250));
};

/// Taps the first widget found by [finder] and settles.
ParityStep tapAndSettle(Finder finder) => (WidgetTester tester) async {
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
};

/// Pumps a fixed amount of time (for running animations).
ParityStep advance(Duration duration) => (WidgetTester tester) async {
  await tester.pump(duration);
};

class _Capture {
  _Capture(this.pixels, this.tree);
  final Uint8List pixels;
  final String tree;
}

final GlobalKey _captureKey = GlobalKey();

String _normalisedRenderTree(WidgetTester tester) {
  final tree = tester.binding.rootElement!.renderObject!.toStringDeep();
  // Repaint statistics of RenderRepaintBoundary and TextStyle debug labels
  // (which record how a style was merged, not what it is) are not part of
  // what is rendered. Drop them together with their wrapped continuation
  // lines.
  final property = RegExp(r'(\w[\w ]*: |[└├╘╚]|^[\s│╎║]*$)');
  final kept = <String>[];
  var skipping = false;
  for (final line in tree.split('\n')) {
    if (line.contains('metrics: ') ||
        line.contains('diagnosis: ') ||
        line.contains('debugLabel: ')) {
      skipping = true;
      continue;
    }
    if (skipping && !property.hasMatch(line)) {
      continue;
    }
    skipping = false;
    kept.add(line);
  }
  return kept.join('\n').replaceAll(RegExp(r'#[0-9a-f]+\b'), '#');
}

Future<List<_Capture>> _run(
  WidgetTester tester, {
  required ThemeData base,
  required ThemeData Function(ThemeData base, MaterialDefaults d)? inject,
  required Widget Function() scene,
  required List<ParityStep> steps,
  required String mode,
  required bool settle,
}) async {
  final captures = <_Capture>[];
  // Unmount everything so every mode starts from fresh state. The focus
  // highlight mode is global state that hover/keyboard steps change, so pin it.
  await tester.pumpWidget(const SizedBox.shrink());
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  await tester.pumpWidget(
    RepaintBoundary(
      key: _captureKey,
      child: MediaQuery(
        data: MediaQueryData.fromView(tester.view),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: base,
            child: Builder(
              builder: (BuildContext context) {
                final theme = inject == null
                    ? base
                    : inject(base, MaterialDefaults.of(context));
                return MaterialApp(
                  key: ValueKey<String>(mode),
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  home: Scaffold(body: Center(child: scene())),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  for (final step in steps) {
    await step(tester);
    final image = await tester.runAsync(
      () => captureImage(_captureKey.currentContext! as Element),
    );
    final bytes = await tester.runAsync(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    image!.dispose();
    captures.add(
      _Capture(bytes!.buffer.asUint8List(), _normalisedRenderTree(tester)),
    );
  }
  for (final cleanup in _cleanups.reversed) {
    await cleanup();
  }
  _cleanups.clear();
  await tester.pumpWidget(const SizedBox.shrink());
  if (settle) {
    await tester.pumpAndSettle();
  }
  return captures;
}

/// Pumps [scene] under the stock theme and under the theme produced by
/// [inject], applying each of [steps] in turn, and expects identical pixels
/// and render trees. Then expects the theme produced by [perturb] to render
/// differently in at least one step.
Future<void> expectRenderParity(
  WidgetTester tester, {
  required ThemeData theme,
  required Widget Function() scene,
  required ThemeData Function(ThemeData base, MaterialDefaults d) inject,
  required ThemeData Function(ThemeData base, MaterialDefaults d) perturb,
  List<ParityStep> steps = const <ParityStep>[idle],
  Size size = const Size(600, 700),
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final base = renderBase(theme);

  final stock = await _run(
    tester,
    base: base,
    inject: null,
    scene: scene,
    steps: steps,
    settle: settle,
    mode: 'stock',
  );
  final injected = await _run(
    tester,
    base: base,
    inject: inject,
    scene: scene,
    steps: steps,
    settle: settle,
    mode: 'injected',
  );
  for (var i = 0; i < steps.length; i++) {
    if (injected[i].tree != stock[i].tree) {
      final a = stock[i].tree.split('\n');
      final b = injected[i].tree.split('\n');
      var first = 0;
      while (first < a.length && first < b.length && a[first] == b[first]) {
        first++;
      }
      final from = first < 12 ? 0 : first - 12;
      debugPrint(
        '--- stock (step $i)\n${a.sublist(from, (first + 4).clamp(0, a.length)).join('\n')}',
      );
      debugPrint(
        '--- injected (step $i)\n${b.sublist(from, (first + 4).clamp(0, b.length)).join('\n')}',
      );
    }
    expect(
      injected[i].tree,
      stock[i].tree,
      reason: 'render tree differs in step $i',
    );
    if (!listEquals(injected[i].pixels, stock[i].pixels)) {
      final w = size.width.toInt();
      var minX = 1 << 30, minY = 1 << 30, maxX = -1, maxY = -1, n = 0;
      for (var p = 0; p < stock[i].pixels.length; p += 4) {
        var same = true;
        for (var c = 0; c < 4; c++) {
          if (stock[i].pixels[p + c] != injected[i].pixels[p + c]) {
            same = false;
          }
        }
        if (!same) {
          n++;
          final x = (p ~/ 4) % w, y = (p ~/ 4) ~/ w;
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
          if (n < 4) {
            debugPrint(
              'px ($x,$y) stock=${stock[i].pixels.sublist(p, p + 4)} '
              'injected=${injected[i].pixels.sublist(p, p + 4)}',
            );
          }
        }
      }
      debugPrint('PIXDIFF step $i: $n px in ($minX,$minY)-($maxX,$maxY)');
    }
    expect(
      listEquals(injected[i].pixels, stock[i].pixels),
      isTrue,
      reason: 'pixels differ in step $i',
    );
  }

  final perturbed = await _run(
    tester,
    base: base,
    inject: perturb,
    scene: scene,
    steps: steps,
    settle: settle,
    mode: 'perturbed',
  );
  var anyDifferent = false;
  for (var i = 0; i < steps.length; i++) {
    if (!listEquals(perturbed[i].pixels, stock[i].pixels)) {
      anyDifferent = true;
    }
  }
  expect(
    anyDifferent,
    isTrue,
    reason:
        'negative control: the perturbed theme rendered identically, '
        'so this scene does not exercise the injected theme',
  );
  await tester.pumpWidget(const SizedBox.shrink());
}
