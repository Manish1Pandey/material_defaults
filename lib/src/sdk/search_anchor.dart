// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/search_anchor.dart.
//
// The class bodies live in ../generated/search_anchor.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'package:flutter/material.dart';

part '../generated/search_anchor.g.dart';

/// Material 3 defaults of [SearchBar].
SearchBarThemeData searchBarDefaults(BuildContext context) {
  final o = _SearchBarDefaultsM3(context);
  _prime(<Object?>[o._colors, o._textTheme]);
  return o.copyWith();
}

/// Material 3 defaults of the view opened by [SearchAnchor].
SearchViewThemeData searchViewDefaults(
  BuildContext context,
  bool isFullScreen,
) {
  final o = _SearchViewDefaultsM3(context, isFullScreen: isFullScreen);
  _prime(<Object?>[o._colors, o._textTheme]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
