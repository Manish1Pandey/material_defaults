// Mirror of the private Material 3 defaults in
// packages/flutter/lib/src/material/menu_anchor.dart.
//
// The class bodies live in ../generated/menu_anchor.g.dart and are produced by
// tool/generate.dart from the SDK's token data. This library supplies the
// private helpers those bodies reference (copied verbatim from the same
// framework file) and exposes the classes to the rest of the package.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

import 'dart:math' as math;

import 'package:flutter/material.dart';

part '../generated/menu_anchor.g.dart';

// The default spacing between the leading icon, label, trailing icon, and
// shortcut label in a _MenuItemLabel.
const double _kLabelItemDefaultSpacing = 12;

// The minimum vertical spacing on the outside of menus.
const double _kMenuVerticalMinPadding = 8;

// How close to the edge of the safe area the menu will be placed.
const double _kMenuViewPadding = 8;

// The minimum horizontal spacing on the outside of the top level menu.
const double _kTopLevelMenuHorizontalMinPadding = 4;

/// Material 3 defaults of [MenuBar].
MenuStyle menuBarDefaults(BuildContext context) {
  final o = _MenuBarDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Material 3 defaults of [MenuItemButton] / [SubmenuButton].
ButtonStyle menuButtonDefaults(BuildContext context) {
  final o = _MenuButtonDefaultsM3(context);
  _prime(<Object?>[o._colors, o._textTheme]);
  return o.copyWith();
}

/// Material 3 defaults of the menus opened by [MenuAnchor] / [SubmenuButton].
MenuStyle menuDefaults(BuildContext context) {
  final o = _MenuDefaultsM3(context);
  _prime(<Object?>[o._colors]);
  return o.copyWith();
}

/// Forces the lazily initialised theme lookups of a defaults object so that
/// the returned snapshot never touches its [BuildContext] again.
void _prime(List<Object?> fields) {}
