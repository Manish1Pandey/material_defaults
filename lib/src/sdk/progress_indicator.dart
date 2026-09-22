// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/progress_indicator.dart.
//
// The class bodies live in ../generated/progress_indicator.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/progress_indicator.g.dart';

/// Material 3 (non-`year2023`) defaults of [CircularProgressIndicator].
ProgressIndicatorThemeData circularProgressDefaults(
  BuildContext context,
  bool indeterminate,
) {
  final o = _CircularProgressIndicatorDefaultsM3(
    context,
    indeterminate: indeterminate,
  );
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 (non-`year2023`) defaults of [LinearProgressIndicator].
ProgressIndicatorThemeData linearProgressDefaults(BuildContext context) {
  final o = _LinearProgressIndicatorDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
