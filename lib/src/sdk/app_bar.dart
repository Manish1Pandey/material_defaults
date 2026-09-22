// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/app_bar.dart.
//
// The class bodies live in ../generated/app_bar.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/app_bar.g.dart';

mixin _ScrollUnderFlexibleConfig {
  TextStyle? get collapsedTextStyle;
  TextStyle? get expandedTextStyle;
  EdgeInsetsGeometry get expandedTitlePadding;
}

/// Material 3 defaults of [AppBar].
///
/// `_AppBarDefaultsM3` declares the token height `toolbarHeight: 64.0`, but
/// `AppBar` never reads it (`widget.toolbarHeight ?? appBarTheme.toolbarHeight
/// ?? kToolbarHeight`), so the effective default, [kToolbarHeight] (56.0), is
/// returned.
///
/// Likewise `AppBar` substitutes `ColorScheme.surfaceContainer` for the
/// background when scrolled under (unless a background color is set) and
/// uses `ColorScheme.surfaceTint` rather than the class's transparent
/// `surfaceTintColor`; the returned `backgroundColor` is therefore a
/// [WidgetStateColor] resolving [WidgetState.scrolledUnder], and
/// `surfaceTintColor` is the scheme's tint.
AppBarThemeData appBarDefaults(BuildContext context) {
  final o = _AppBarDefaultsM3(context);
  _prime(<Object?>[o._theme, o._colors, o._textTheme]);
  final ColorScheme scheme = Theme.of(context).colorScheme;
  final Color idle = o.backgroundColor!;
  return o.copyWith(
    toolbarHeight: kToolbarHeight,
    backgroundColor: WidgetStateColor.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.scrolledUnder)
          ? scheme.surfaceContainer
          : idle,
    ),
    surfaceTintColor: scheme.surfaceTint,
  );
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
