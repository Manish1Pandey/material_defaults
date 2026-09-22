// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/snack_bar.dart.
//
// The class bodies live in ../generated/snack_bar.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/snack_bar.g.dart';

/// Material 3 defaults of [SnackBar].
///
/// `SnackBar` applies the token `shape` only to floating snack bars
/// (`widget.shape ?? snackBarTheme.shape ?? (isFloatingSnackBar ?
/// defaults.shape : null)`), so the fixed variant has no shape.
SnackBarThemeData snackBarDefaults(BuildContext context, bool floating) {
  final o = _SnackbarDefaultsM3(context);
  _prime(<Object?>[o._theme, o._colors]);
  if (floating) {
    return o.copyWith(behavior: SnackBarBehavior.floating);
  }
  return SnackBarThemeData(
    backgroundColor: o.backgroundColor,
    actionTextColor: o.actionTextColor,
    disabledActionTextColor: o.disabledActionTextColor,
    contentTextStyle: o.contentTextStyle,
    elevation: o.elevation,
    behavior: o.behavior,
    width: o.width,
    insetPadding: o.insetPadding,
    showCloseIcon: o.showCloseIcon,
    closeIconColor: o.closeIconColor,
    actionOverflowThreshold: o.actionOverflowThreshold,
    actionBackgroundColor: o.actionBackgroundColor,
    disabledActionBackgroundColor: o.disabledActionBackgroundColor,
    dismissDirection: o.dismissDirection,
  );
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
