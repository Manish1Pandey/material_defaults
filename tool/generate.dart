// Copyright 2026 Manish Kumar Panday. MIT License.
//
// Regenerates lib/src/generated/ from the Material Design token data that
// ships inside a local Flutter SDK checkout.
//
// Usage (from the package root):
//
//   dart run tool/generate.dart [--flutter-root <path>] [--check]
//
// How it works:
//
// 1. Reads every token file in <flutter>/dev/tools/gen_defaults/data/*.json.
// 2. Writes a throw-away runner script into a temp directory. The runner
//    imports the SDK's own gen_defaults templates (the exact code Flutter uses
//    to produce `_FilledButtonDefaultsM3` & co.) and invokes them with the
//    same constructor arguments as <flutter>/dev/tools/gen_defaults/bin/
//    gen_defaults.dart. Every template's `generate()` output is collected.
// 3. Verifies that each generated block is byte-for-byte identical to the
//    block checked into <flutter>/packages/flutter/lib/src/material/*.dart.
//    If a single block differs, generation fails: the output of this package
//    must be the code the installed framework actually runs.
// 4. Writes one `part` file per framework source file into
//    lib/src/generated/, plus lib/src/generated/token_info.g.dart with the
//    Flutter version / revision and the token data version.
//
// With --check nothing is written; the command exits non-zero when the
// committed files are out of date with respect to the given SDK.

import 'dart:convert';
import 'dart:io';

/// Framework source files (under packages/flutter/lib/src/material) whose
/// generated blocks this package mirrors. Each maps to a hand-written library
/// in `lib/src/sdk/<name>.dart` that supplies the private helpers the blocks
/// reference and exposes the classes to the rest of the package.
const List<String> includedFiles = <String>[
  'action_chip.dart',
  'app_bar.dart',
  'badge.dart',
  'banner.dart',
  'bottom_app_bar.dart',
  'bottom_sheet.dart',
  'card.dart',
  'checkbox.dart',
  'chip.dart',
  'choice_chip.dart',
  'date_picker_theme.dart',
  'dialog.dart',
  'divider.dart',
  'drawer.dart',
  'elevated_button.dart',
  'expansion_tile.dart',
  'filled_button.dart',
  'filter_chip.dart',
  'floating_action_button.dart',
  'icon_button.dart',
  'input_chip.dart',
  'input_decorator.dart',
  'list_tile.dart',
  'menu_anchor.dart',
  'navigation_bar.dart',
  'navigation_drawer.dart',
  'navigation_rail.dart',
  'outlined_button.dart',
  'popup_menu.dart',
  'progress_indicator.dart',
  'radio.dart',
  'range_slider.dart',
  'search_anchor.dart',
  'segmented_button.dart',
  'slider.dart',
  'snack_bar.dart',
  'switch.dart',
  'tabs.dart',
  'text_button.dart',
];

const String _headerComment = '''

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
''';

const String _footerComment = '''
// dart format on
''';

Future<void> main(List<String> args) async {
  String? flutterRoot;
  var check = false;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--flutter-root':
        flutterRoot = args[++i];
      case '--check':
        check = true;
      case '-h' || '--help':
        stdout.writeln(
          'dart run tool/generate.dart [--flutter-root <path>] [--check]',
        );
        return;
      default:
        stderr.writeln('Unknown argument: ${args[i]}');
        exit(64);
    }
  }
  flutterRoot ??= Platform.environment['FLUTTER_ROOT'] ?? _flutterFromPath();
  if (flutterRoot == null) {
    stderr.writeln(
      'Could not locate the Flutter SDK. Pass --flutter-root or set FLUTTER_ROOT.',
    );
    exit(66);
  }
  final root = Directory(flutterRoot).absolute.path;
  final genDefaults = '$root/dev/tools/gen_defaults';
  final materialLib = '$root/packages/flutter/lib/src/material';
  if (!File('$genDefaults/bin/gen_defaults.dart').existsSync()) {
    stderr.writeln('No gen_defaults tool found under $root.');
    exit(66);
  }

  final version = _readSdkVersion(root);
  final tokenVersions = _readTokenVersions('$genDefaults/data');

  // 1 + 2: run the SDK's templates.
  final generated = await _runSdkTemplates(genDefaults, materialLib);

  // 3: verify against the checked-in framework blocks and group by file.
  final byFile = <String, List<MapEntry<String, String>>>{};
  final failures = <String>[];
  for (final file in includedFiles) {
    final source = File('$materialLib/$file').readAsStringSync();
    final blocks = _checkedInBlocks(source);
    if (blocks.isEmpty) {
      failures.add('$file: no generated blocks found in the SDK source');
      continue;
    }
    final entries = <MapEntry<String, String>>[];
    for (final block in blocks.entries) {
      final ours = generated[block.key];
      if (ours == null) {
        failures.add('$file: SDK block "${block.key}" has no template output');
        continue;
      }
      if (ours['file'] != '$materialLib/$file') {
        failures.add(
          '$file: block "${block.key}" is produced for ${ours['file']}',
        );
        continue;
      }
      if (ours['code'] != block.value) {
        failures.add(
          '$file: template output for "${block.key}" differs from the '
          'code checked into the framework',
        );
        continue;
      }
      entries.add(MapEntry<String, String>(block.key, block.value));
    }
    byFile[file] = entries;
  }
  if (failures.isNotEmpty) {
    stderr.writeln('Generation failed:\n  ${failures.join('\n  ')}');
    exit(1);
  }

  // 4: emit.
  final outDir = Directory('lib/src/generated');
  final outputs = <String, String>{};
  for (final entry in byFile.entries) {
    final base = entry.key.replaceAll('.dart', '');
    outputs['${outDir.path}/$base.g.dart'] = _partFile(
      base,
      entry.key,
      entry.value,
      version,
    );
  }
  outputs['${outDir.path}/token_info.g.dart'] = _tokenInfoFile(
    version,
    tokenVersions,
    byFile,
  );

  outputs.addAll(await _format(outputs));

  if (check) {
    final stale = <String>[
      for (final out in outputs.entries)
        if (!File(out.key).existsSync() ||
            File(out.key).readAsStringSync() != out.value)
          out.key,
    ];
    if (stale.isNotEmpty) {
      stderr.writeln('Out of date:\n  ${stale.join('\n  ')}');
      exit(1);
    }
    stdout.writeln(
      'Up to date with Flutter ${version['frameworkVersion']} '
      '(${outputs.length} files).',
    );
    return;
  }

  outDir.createSync(recursive: true);
  for (final out in outputs.entries) {
    File(out.key).writeAsStringSync(out.value);
  }
  final blockCount = byFile.values.fold<int>(0, (n, e) => n + e.length);
  stdout.writeln(
    'Generated $blockCount blocks from ${byFile.length} framework files '
    '(Flutter ${version['frameworkVersion']}, tokens '
    '${tokenVersions.keys.join(', ')}); all identical to the SDK source.',
  );
}

/// Runs `dart format` over [outputs] in a scratch directory so the committed
/// files are formatter-clean (the `// dart format off` regions are kept
/// verbatim by the formatter itself).
Future<Map<String, String>> _format(Map<String, String> outputs) async {
  final temp = Directory.systemTemp.createTempSync('material_defaults_fmt');
  try {
    final names = <String, String>{};
    var i = 0;
    for (final out in outputs.entries) {
      final path = '${temp.path}/f${i++}.dart';
      File(path).writeAsStringSync(out.value);
      names[out.key] = path;
    }
    final result = await Process.run(Platform.resolvedExecutable, <String>[
      'format',
      '--language-version=3.9',
      temp.path,
    ]);
    if (result.exitCode != 0) {
      stderr.writeln('dart format failed:\n${result.stdout}\n${result.stderr}');
      exit(1);
    }
    return names.map(
      (key, path) =>
          MapEntry<String, String>(key, File(path).readAsStringSync()),
    );
  } finally {
    temp.deleteSync(recursive: true);
  }
}

String? _flutterFromPath() {
  final result = Process.runSync(
    Platform.isWindows ? 'where' : 'which',
    <String>['flutter'],
  );
  if (result.exitCode != 0) {
    return null;
  }
  final bin = File((result.stdout as String).split('\n').first.trim());
  return bin.resolveSymbolicLinksSync().replaceAll(
    RegExp(r'[/\\]bin[/\\]flutter(\.bat)?$'),
    '',
  );
}

Map<String, String> _readSdkVersion(String root) {
  final file = File('$root/bin/cache/flutter.version.json');
  if (!file.existsSync()) {
    stderr.writeln(
      'Missing $root/bin/cache/flutter.version.json; run `flutter --version` once.',
    );
    exit(66);
  }
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return <String, String>{
    'frameworkVersion': json['frameworkVersion'] as String,
    'frameworkRevision': json['frameworkRevision'] as String,
    'channel': json['channel'] as String,
  };
}

Map<String, List<String>> _readTokenVersions(String dataDir) {
  final versions = <String, List<String>>{};
  final files =
      Directory(dataDir)
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    versions
        .putIfAbsent(json['version'] as String, () => <String>[])
        .add(file.uri.pathSegments.last);
  }
  return versions;
}

/// Extracts `blockName -> code` for every generated block in [source], where
/// code is the text between the standard header and footer comments.
Map<String, String> _checkedInBlocks(String source) {
  final result = <String, String>{};
  final begin = RegExp(r'\n// BEGIN GENERATED TOKEN PROPERTIES - (.+)\n');
  for (final match in begin.allMatches(source)) {
    final name = match.group(1)!;
    final endMarker = '\n// END GENERATED TOKEN PROPERTIES - $name\n';
    final end = source.indexOf(endMarker, match.end);
    if (end < 0) {
      continue;
    }
    var body = source.substring(match.end, end);
    if (!body.startsWith(_headerComment) || !body.endsWith(_footerComment)) {
      throw StateError('Unexpected block framing for "$name".');
    }
    body = body.substring(
      _headerComment.length,
      body.length - _footerComment.length,
    );
    result[name] = body;
  }
  return result;
}

/// Runs the SDK templates in a separate isolate-free process so that the SDK
/// sources are imported exactly as they are, without copying them.
Future<Map<String, Map<String, String>>> _runSdkTemplates(
  String genDefaults,
  String materialLib,
) async {
  final main = File('$genDefaults/bin/gen_defaults.dart').readAsStringSync();
  final invocation = RegExp(
    r'^\s*(\w+Template)\((.*)\)\.updateFile\(\);\s*$',
    multiLine: true,
  );
  final calls = <String>[];
  final importNames = <String>{};
  for (final match in invocation.allMatches(main)) {
    final args = match.group(2)!;
    final fileMatch = RegExp(
      r"'\$materialLib/([a-z_]+\.dart)'",
    ).firstMatch(args);
    if (fileMatch == null || !includedFiles.contains(fileMatch.group(1))) {
      continue;
    }
    calls.add('  _add(${match.group(1)}($args));');
    importNames.add(match.group(1)!);
  }
  final imports = <String>{
    for (final match in RegExp(
      r"^import 'package:gen_defaults/(\w+)\.dart';",
      multiLine: true,
    ).allMatches(main))
      match.group(1)!,
  };
  final temp = Directory.systemTemp.createTempSync('material_defaults_gen');
  try {
    final out = File('${temp.path}/out.json');
    final libUri = Directory('$genDefaults/lib').uri;
    final runner = StringBuffer()
      ..writeln("import 'dart:convert';")
      ..writeln("import 'dart:io';");
    for (final name in <String>{...imports, 'template'}) {
      runner.writeln("import '${libUri.resolve('$name.dart')}';");
    }
    runner.write('''
const String materialLib = '$materialLib';
const String dataDir = '$genDefaults/data';
final Map<String, Map<String, String>> _out = <String, Map<String, String>>{};
void _add(TokenTemplate t) {
  _out[t.blockName] = <String, String>{'file': t.fileName, 'code': t.generate()};
}
Map<String, dynamic> _read(File f) => jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
void main() {
  final versionMap = <String, List<String>>{};
  final tokens = <String, dynamic>{};
  for (final FileSystemEntity f in Directory(dataDir).listSync()) {
    final Map<String, dynamic> t = _read(f as File);
    final String version = t.remove('version') as String;
    (versionMap[version] ??= <String>[]).add(f.uri.pathSegments.last);
    tokens.addAll(t);
  }
  tokenLogger.init(allTokens: tokens, versionMap: versionMap);
${calls.join('\n')}
  File('${out.path}').writeAsStringSync(jsonEncode(_out));
}
''');
    final script = File('${temp.path}/runner.dart')
      ..writeAsStringSync(runner.toString());
    final result = await Process.run(Platform.resolvedExecutable, <String>[
      script.path,
    ]);
    if (result.exitCode != 0 || !out.existsSync()) {
      stderr
        ..writeln('Template runner failed (${result.exitCode}):')
        ..writeln(result.stdout)
        ..writeln(result.stderr);
      exit(1);
    }
    final decoded = jsonDecode(out.readAsStringSync()) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry<String, Map<String, String>>(
        k,
        (v as Map<String, dynamic>).cast<String, String>(),
      ),
    );
  } finally {
    temp.deleteSync(recursive: true);
  }
}

String _partFile(
  String base,
  String sdkFile,
  List<MapEntry<String, String>> blocks,
  Map<String, String> version,
) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('//')
    ..writeln('// Produced by tool/generate.dart by running the gen_defaults')
    ..writeln('// templates of Flutter ${version['frameworkVersion']}')
    ..writeln('// (${version['frameworkRevision']}) over the token data in')
    ..writeln('// dev/tools/gen_defaults/data. Each block below is verified to')
    ..writeln('// be identical to the block in')
    ..writeln('// packages/flutter/lib/src/material/$sdkFile.')
    ..writeln('//')
    ..writeln('// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).')
    ..writeln()
    ..writeln(
      '// ignore_for_file: deprecated_member_use, unused_element, '
      'unused_field, prefer_const_constructors',
    )
    ..writeln()
    ..writeln("part of '../sdk/$base.dart';");
  for (final block in blocks) {
    buffer
      ..writeln()
      ..writeln('// BEGIN GENERATED TOKEN PROPERTIES - ${block.key}')
      ..write(_headerComment)
      ..write(block.value)
      ..write(_footerComment)
      ..writeln()
      ..writeln('// END GENERATED TOKEN PROPERTIES - ${block.key}');
  }
  return buffer.toString();
}

String _tokenInfoFile(
  Map<String, String> version,
  Map<String, List<String>> tokenVersions,
  Map<String, List<MapEntry<String, String>>> byFile,
) {
  final blocks = <String>[
    for (final entry in byFile.entries)
      for (final block in entry.value) block.key,
  ]..sort();
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Produced by tool/generate.dart.')
    ..writeln()
    ..writeln('/// Flutter framework version whose token data and gen_defaults')
    ..writeln('/// templates produced the generated defaults.')
    ..writeln(
      "const String generatedFlutterVersion = '${version['frameworkVersion']}';",
    )
    ..writeln()
    ..writeln(
      '/// Flutter framework git revision of [generatedFlutterVersion].',
    )
    ..writeln(
      "const String generatedFlutterRevision = '${version['frameworkRevision']}';",
    )
    ..writeln()
    ..writeln('/// Versions declared by the Material token data files.')
    ..writeln('const List<String> generatedTokenDataVersions = <String>[')
    ..writeAll(<String>[for (final v in tokenVersions.keys) "  '$v',\n"])
    ..writeln('];')
    ..writeln()
    ..writeln('/// Names of the generated framework blocks mirrored here.')
    ..writeln('const List<String> generatedBlocks = <String>[')
    ..writeAll(<String>[for (final b in blocks) "  '$b',\n"])
    ..writeln('];');
  return buffer.toString();
}
