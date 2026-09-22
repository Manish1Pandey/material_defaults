// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Produced by tool/generate.dart by running the gen_defaults
// templates of Flutter 3.41.8
// (02085feb3f5d8a8156e5e28512b9d99351d510c0) over the token data in
// dev/tools/gen_defaults/data. Each block below is verified to
// be identical to the block in
// packages/flutter/lib/src/material/drawer.dart.
//
// Portions copyright 2014 The Flutter Authors (BSD-3-Clause).

// ignore_for_file: deprecated_member_use, unused_element, unused_field, prefer_const_constructors

part of '../sdk/drawer.dart';

// BEGIN GENERATED TOKEN PROPERTIES - Drawer

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// dart format off
class _DrawerDefaultsM3 extends DrawerThemeData {
  _DrawerDefaultsM3(this.context)
      : super(
          elevation: 1.0,
          clipBehavior: Clip.hardEdge,
        );

  final BuildContext context;
  late final TextDirection direction = Directionality.of(context);

  @override
  Color? get backgroundColor => Theme.of(context).colorScheme.surfaceContainerLow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  Color? get shadowColor => Colors.transparent;

  // There isn't currently a token for this value, but it is shown in the spec,
  // so hard coding here for now.
  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
    borderRadius: const BorderRadiusDirectional.horizontal(
      end: Radius.circular(16.0),
    ).resolve(direction),
  );

  // There isn't currently a token for this value, but it is shown in the spec,
  // so hard coding here for now.
  @override
  ShapeBorder? get endShape => RoundedRectangleBorder(
    borderRadius: const BorderRadiusDirectional.horizontal(
      start: Radius.circular(16.0),
    ).resolve(direction),
  );
}
// dart format on

// END GENERATED TOKEN PROPERTIES - Drawer
