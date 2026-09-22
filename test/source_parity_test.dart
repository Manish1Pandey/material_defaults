// Source parity: the committed generated code must be byte-identical to the
// token-generated blocks compiled into the Flutter framework these tests run
// against, and MaterialDefaults.tokenVersion must name that framework.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';

/// Locates the Flutter SDK running this test.
String? _flutterRoot() {
  final fromEnv = Platform.environment['FLUTTER_ROOT'];
  if (fromEnv != null && Directory(fromEnv).existsSync()) {
    return fromEnv;
  }
  final exe = Platform.resolvedExecutable;
  final index = exe.indexOf(
    '${Platform.pathSeparator}bin${Platform.pathSeparator}cache',
  );
  return index < 0 ? null : exe.substring(0, index);
}

Map<String, String> _blocks(String source) {
  final result = <String, String>{};
  final begin = RegExp(r'\n// BEGIN GENERATED TOKEN PROPERTIES - (.+)\n');
  for (final match in begin.allMatches(source)) {
    final name = match.group(1)!;
    final end = source.indexOf(
      '\n// END GENERATED TOKEN PROPERTIES - $name\n',
      match.end,
    );
    result[name] = source.substring(match.end, end);
  }
  return result;
}

void main() {
  final root = _flutterRoot();
  final sdkMaterial = root == null
      ? null
      : Directory('$root/packages/flutter/lib/src/material');
  final skip = sdkMaterial == null || !sdkMaterial.existsSync()
      ? 'Flutter SDK sources not found'
      : null;

  test('tokenVersion names the running framework', () {
    final json =
        jsonDecode(
              File('$root/bin/cache/flutter.version.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    expect(MaterialDefaults.tokenVersion, json['frameworkVersion']);
    expect(MaterialDefaults.flutterRevision, json['frameworkRevision']);
  }, skip: skip);

  test('token data version matches the SDK token files', () {
    final versions = <String>{
      for (final file in Directory(
        '$root/dev/tools/gen_defaults/data',
      ).listSync().whereType<File>())
        (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)['version']
            as String,
    };
    expect(MaterialDefaults.tokenDataVersions.toSet(), versions);
  }, skip: skip);

  test('every generated block is identical to the framework block', () {
    var compared = 0;
    for (final file in Directory(
      'lib/src/generated',
    ).listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (name == 'token_info.g.dart') {
        continue;
      }
      final ours = _blocks(file.readAsStringSync());
      final theirs = _blocks(
        File(
          '${sdkMaterial!.path}/${name.replaceAll('.g.dart', '.dart')}',
        ).readAsStringSync(),
      );
      expect(ours.keys.toSet(), theirs.keys.toSet(), reason: name);
      for (final block in ours.keys) {
        expect(ours[block], theirs[block], reason: '$name: $block');
        compared++;
      }
    }
    expect(compared, MaterialDefaults.generatedBlocks.length);
    expect(compared, 47);
  }, skip: skip);
}
