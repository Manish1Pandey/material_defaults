// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/text_button.dart.
//
// The class bodies live in ../generated/text_button.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/text_button.g.dart';

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final double defaultFontSize = theme.textTheme.labelLarge?.fontSize ?? 14.0;
  final double effectiveTextScale =
      MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;
  return ButtonStyleButton.scaledPadding(
    theme.useMaterial3
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.all(8),
    const EdgeInsets.symmetric(horizontal: 8),
    const EdgeInsets.symmetric(horizontal: 4),
    effectiveTextScale,
  );
}

/// Material 3 defaults of [TextButton].
ButtonStyle textButtonDefaults(BuildContext context) {
  final o = _TextButtonDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
