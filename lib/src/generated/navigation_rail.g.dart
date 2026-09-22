// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Produced by tool/generate.dart by running the gen_defaults
// templates of Flutter 3.41.8
// (02085feb3f5d8a8156e5e28512b9d99351d510c0) over the token data in
// dev/tools/gen_defaults/data. Each block below is verified to
// be identical to the block in
// packages/flutter/lib/src/material/navigation_rail.dart.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

// ignore_for_file: deprecated_member_use, unused_element, unused_field, prefer_const_constructors

part of '../sdk/navigation_rail.dart';

// BEGIN GENERATED TOKEN PROPERTIES - NavigationRail

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _NavigationRailDefaultsM3 extends NavigationRailThemeData {
  _NavigationRailDefaultsM3(this.context)
    : super(
        elevation: 0.0,
        groupAlignment: -1,
        labelType: NavigationRailLabelType.none,
        useIndicator: true,
        minWidth: 80.0,
        minExtendedWidth: 256,
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override Color? get backgroundColor => _colors.surface;

  @override TextStyle? get unselectedLabelTextStyle {
    return _textTheme.labelMedium!.copyWith(color: _colors.onSurface);
  }

  @override TextStyle? get selectedLabelTextStyle {
    return _textTheme.labelMedium!.copyWith(color: _colors.onSurface);
  }

  @override IconThemeData? get unselectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.onSurfaceVariant,
    );
  }

  @override IconThemeData? get selectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.onSecondaryContainer,
    );
  }

  @override Color? get indicatorColor => _colors.secondaryContainer;

  @override ShapeBorder? get indicatorShape => const StadiumBorder();
}
// dart format on

// END GENERATED TOKEN PROPERTIES - NavigationRail
