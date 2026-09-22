// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Produced by tool/generate.dart by running the gen_defaults
// templates of Flutter 3.41.8
// (02085feb3f5d8a8156e5e28512b9d99351d510c0) over the token data in
// dev/tools/gen_defaults/data. Each block below is verified to
// be identical to the block in
// packages/flutter/lib/src/material/card.dart.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

// ignore_for_file: deprecated_member_use, unused_element, unused_field, prefer_const_constructors

part of '../sdk/card.dart';

// BEGIN GENERATED TOKEN PROPERTIES - Card

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _CardDefaultsM3 extends CardThemeData {
  _CardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 1.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surfaceContainerLow;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)));
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Card

// BEGIN GENERATED TOKEN PROPERTIES - FilledCard

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _FilledCardDefaultsM3 extends CardThemeData {
  _FilledCardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 0.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surfaceContainerHighest;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)));
}
// dart format on

// END GENERATED TOKEN PROPERTIES - FilledCard

// BEGIN GENERATED TOKEN PROPERTIES - OutlinedCard

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _OutlinedCardDefaultsM3 extends CardThemeData {
  _OutlinedCardDefaultsM3(this.context)
    : super(
        clipBehavior: Clip.none,
        elevation: 0.0,
        margin: const EdgeInsets.all(4.0),
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get color => _colors.surface;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape =>
    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))).copyWith(
      side: BorderSide(color: _colors.outlineVariant)
    );
}
// dart format on

// END GENERATED TOKEN PROPERTIES - OutlinedCard
