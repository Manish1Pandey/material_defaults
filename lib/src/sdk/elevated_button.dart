// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/elevated_button.dart.
//
// The class bodies live in ../generated/elevated_button.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/elevated_button.g.dart';

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  final padding1x = theme.useMaterial3 ? 24.0 : 16.0;
  final double defaultFontSize = theme.textTheme.labelLarge?.fontSize ?? 14.0;
  final double effectiveTextScale =
      MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;

  return ButtonStyleButton.scaledPadding(
    EdgeInsets.symmetric(horizontal: padding1x),
    EdgeInsets.symmetric(horizontal: padding1x / 2),
    EdgeInsets.symmetric(horizontal: padding1x / 2 / 2),
    effectiveTextScale,
  );
}

/// Material 3 defaults of [ElevatedButton].
ButtonStyle elevatedButtonDefaults(BuildContext context) {
  final o = _ElevatedButtonDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
