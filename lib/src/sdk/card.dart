// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/card.dart.
//
// The class bodies live in ../generated/card.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/card.g.dart';

/// Material 3 defaults of [Card].
CardThemeData cardDefaults(BuildContext context) {
  final o = _CardDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [Card.filled].
CardThemeData filledCardDefaults(BuildContext context) {
  final o = _FilledCardDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [Card.outlined].
CardThemeData outlinedCardDefaults(BuildContext context) {
  final o = _OutlinedCardDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
