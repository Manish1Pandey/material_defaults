// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/action_chip.dart.
//
// The class bodies live in ../generated/action_chip.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

part '../generated/action_chip.g.dart';

enum _ChipVariant { flat, elevated }

/// Material 3 defaults of [ActionChip] / [ActionChip.elevated].
ChipThemeData actionChipDefaults(
  BuildContext context,
  bool isEnabled,
  bool elevated,
) {
  final o = _ActionChipDefaultsM3(
    context,
    isEnabled,
    elevated ? _ChipVariant.elevated : _ChipVariant.flat,
  );
  _prime(<Object?>[o._colors, o._textTheme]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
