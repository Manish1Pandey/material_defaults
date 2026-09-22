// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/floating_action_button.dart.
//
// The class bodies live in ../generated/floating_action_button.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/floating_action_button.g.dart';

enum _FloatingActionButtonType { regular, small, large, extended }

/// Material 3 defaults of [FloatingActionButton]; [type] is one of
/// `regular`, `small`, `large`, `extended`.
FloatingActionButtonThemeData fabDefaults(
  BuildContext context,
  String type,
  bool hasChild,
) {
  final o = _FABDefaultsM3(
    context,
    _FloatingActionButtonType.values.byName(type),
    hasChild,
  );
  _prime(<Object?>[o._colors, o._textTheme]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
