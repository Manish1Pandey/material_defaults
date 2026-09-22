# material_defaults — Specification

## Purpose

Material 3 widgets compute their default look in private classes
(`_FilledButtonDefaultsM3`, `_InputDecoratorDefaultsM3`, …) that Flutter
generates from the Material Design token database with
`dev/tools/gen_defaults`. Because the classes are private, app developers
cannot read the defaults to build custom widgets that match Material, or to
override one property of a theme while keeping the rest
([flutter/flutter#130135](https://github.com/flutter/flutter/issues/130135)).

`material_defaults` exposes those defaults publicly and context-aware:

```dart
final d = MaterialDefaults.of(context);
final ButtonStyle filled = d.filledButton;
final Color? bg = filled.backgroundColor?.resolve(<WidgetState>{});
```

## Functional requirements

| ID | Requirement |
|----|-------------|
| FR1 | `MaterialDefaults.of(context)` returns an object whose members return the Material 3 default style/theme object of a component, resolved against `Theme.of(context)` (color scheme, text theme, visual density, platform) and `MediaQuery` (text scaling), exactly as the framework does. |
| FR2 | Values must be *the same code* the installed framework runs: produced by running the SDK's own `gen_defaults` templates over the SDK's token JSON; generation fails if any block differs from the block checked into `packages/flutter/lib/src/material`. |
| FR3 | Generation is reproducible: `dart run tool/generate.dart` regenerates `lib/src/generated/`; `--check` detects stale output. |
| FR4 | `MaterialDefaults.tokenVersion` records the Flutter version the tokens came from; `flutterRevision` and `tokenDataVersions` record the exact revision and token data version. |
| FR5 | Every exposed member is proven by widget tests to equal what the real widget uses, in light and dark color schemes. Members that cannot be proven are not exposed. |
| FR6 | Parameterised variants mirror the framework's constructor inputs (enabled/selected chips, toggleable icon buttons, FAB sizes, scrollable tabs, determinate progress, full-screen search view). |
| FR7 | Returned objects are ordinary framework types (`ButtonStyle`, `ChipThemeData`, …), so `copyWith`, `merge` and `resolve` work and they can be passed straight into `ThemeData`. |

## Public API sketch

```dart
class MaterialDefaults {
  factory MaterialDefaults.of(BuildContext context);
  static const String tokenVersion;          // e.g. '3.41.8'
  static const String flutterRevision;
  static const List<String> tokenDataVersions; // e.g. ['6_1_0']
  BuildContext get context;
  bool get appliesToCurrentTheme;            // Theme.of(context).useMaterial3

  // Buttons
  ButtonStyle get elevatedButton, filledButton, filledTonalButton,
      outlinedButton, textButton, menuButton;
  ButtonStyle iconButton({bool toggleable}), filledIconButton(...),
      filledTonalIconButton(...), outlinedIconButton(...);
  FloatingActionButtonThemeData get floatingActionButton,
      smallFloatingActionButton, largeFloatingActionButton;
  FloatingActionButtonThemeData extendedFloatingActionButton({bool hasIcon});
  SegmentedButtonThemeData get segmentedButton;

  // Containment / surfaces
  CardThemeData get card, filledCard, outlinedCard;
  DialogThemeData get dialog, fullscreenDialog;
  BottomSheetThemeData get bottomSheet;
  SnackBarThemeData snackBar({bool floating});
  MaterialBannerThemeData get banner;
  DividerThemeData get divider;
  ListTileThemeData get listTile;
  ExpansionTileThemeData get expansionTile;

  // Chips
  ChipThemeData chip({bool enabled});
  ChipThemeData actionChip({bool enabled, bool elevated});
  ChipThemeData filterChip({bool enabled, bool selected, bool elevated});
  ChipThemeData choiceChip({bool enabled, bool selected, bool elevated});
  ChipThemeData inputChip({bool enabled, bool selected});

  // Inputs & selection
  InputDecorationThemeData get inputDecoration;
  CheckboxThemeData get checkbox;
  RadioThemeData get radio;
  SwitchThemeData get switchTheme;
  SliderThemeData get slider, rangeSlider;      // year2023: false variants
  SearchBarThemeData get searchBar;
  SearchViewThemeData searchView({bool fullScreen});
  DatePickerThemeData get datePicker;

  // Navigation
  AppBarThemeData get appBar;
  BottomAppBarThemeData get bottomAppBar;
  NavigationBarThemeData get navigationBar;
  NavigationRailThemeData get navigationRail;
  NavigationDrawerThemeData get navigationDrawer;
  DrawerThemeData get drawer;
  TabBarThemeData tabBar({bool isScrollable}), secondaryTabBar(...);
  MenuStyle get menu, menuBar;
  PopupMenuThemeData get popupMenu;

  // Feedback
  BadgeThemeData get badge;
  ProgressIndicatorThemeData get linearProgressIndicator;
  ProgressIndicatorThemeData circularProgressIndicator({bool indeterminate});
}
```

## Can / Cannot

| Can | Cannot |
|-----|--------|
| Return the exact M3 defaults of 47 generated framework classes for the Flutter version they were generated from. | Guarantee exactness on a *different* Flutter version: defaults change between releases. The package pins `flutter: ">=3.41.0"` and records `tokenVersion`; regenerate for another SDK. |
| Resolve every `WidgetStateProperty` for any state set, `copyWith`/`merge` them, feed them into `ThemeData`. | Expose defaults that are hand-written in the framework rather than token-generated (e.g. `Tooltip`, `DropdownMenu`, `year2023: true` Slider/progress indicators, `TimePicker` which extends a private base class). They are not exposed rather than approximated. |
| Reflect `Theme` color scheme, text theme, visual density, tap-target size, text scaling, platform. | Return Material 2 defaults. When `ThemeData.useMaterial3` is false the widgets use other (M2) classes; `appliesToCurrentTheme` reports this. |
| Regenerate from any local Flutter checkout with `tool/generate.dart`, failing loudly if templates' output ≠ framework source. | Run the generator without a Flutter SDK checkout that contains `dev/tools/gen_defaults` (the regular SDK install does). |

## Platform matrix

Pure Dart/Flutter, no platform channels.

| Android | iOS | Web | macOS | Windows | Linux |
|---------|-----|-----|-------|---------|-------|
| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

Example builds verified here: web, Android (apk), iOS (no codesign), macOS.

## Effective-value corrections

A few private classes declare values their widget never reads. Because FR5
requires *what the widget renders*, these members return the effective value
(each is documented in dartdoc and covered by render parity):

| Member | Private class says | Widget actually uses |
|--------|--------------------|----------------------|
| `appBar.toolbarHeight` | 64.0 | `kToolbarHeight` (56.0) |
| `appBar.backgroundColor` | `surface` | `surface`, or `surfaceContainer` when scrolled under (returned as a `WidgetStateColor`) |
| `appBar.surfaceTintColor` | transparent | `colorScheme.surfaceTint` |
| `banner.elevation` | 1.0 | 0.0 |
| `snackBar()` (fixed) `shape` | rounded 4 | none (the shape is only applied to floating snack bars) |

All members return value snapshots (`copyWith()` after forcing the class's
lazy theme lookups), so they never touch their `BuildContext` again.

## Verification strategy

1. **Source parity** (generator + test): each generated block is byte-identical
   to the installed framework's block.
2. **Instance parity**: where the framework exposes its private defaults object
   (`ButtonStyleButton.defaultStyleOf`, `MenuItemButton.defaultStyleOf`,
   `RawChip.defaultProperties`, `DatePickerTheme.defaults`), every
   diagnostics property of ours is compared to theirs, resolving each
   `WidgetStateProperty` over all combinations of the relevant states.
3. **Render parity** (all other components): the real widget is pumped once
   with the stock theme and once with our defaults injected as the component
   theme, in several interaction states; the rendered pixels and the render
   tree must be identical. A deliberately perturbed copy must render
   differently (negative control proving the scene is sensitive).
4. Everything above runs for a light and a dark `ColorScheme`.
