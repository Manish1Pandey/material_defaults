// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/icon_button.dart.
//
// The class bodies live in ../generated/icon_button.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/icon_button.g.dart';

/// Material 3 defaults of [IconButton].
ButtonStyle iconButtonDefaults(BuildContext context, bool toggleable) {
  final o = _IconButtonDefaultsM3(context, toggleable);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [IconButton.filled].
ButtonStyle filledIconButtonDefaults(BuildContext context, bool toggleable) {
  final o = _FilledIconButtonDefaultsM3(context, toggleable);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [IconButton.filledTonal].
ButtonStyle filledTonalIconButtonDefaults(
  BuildContext context,
  bool toggleable,
) {
  final o = _FilledTonalIconButtonDefaultsM3(context, toggleable);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [IconButton.outlined].
ButtonStyle outlinedIconButtonDefaults(BuildContext context, bool toggleable) {
  final o = _OutlinedIconButtonDefaultsM3(context, toggleable);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
