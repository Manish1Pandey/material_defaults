import 'package:flutter/material.dart';

import 'generated/token_info.g.dart' as info;
import 'sdk/action_chip.dart';
import 'sdk/app_bar.dart';
import 'sdk/badge.dart';
import 'sdk/banner.dart';
import 'sdk/bottom_app_bar.dart';
import 'sdk/bottom_sheet.dart';
import 'sdk/card.dart';
import 'sdk/checkbox.dart';
import 'sdk/chip.dart';
import 'sdk/choice_chip.dart';
import 'sdk/date_picker_theme.dart';
import 'sdk/dialog.dart';
import 'sdk/divider.dart';
import 'sdk/drawer.dart';
import 'sdk/elevated_button.dart';
import 'sdk/expansion_tile.dart';
import 'sdk/filled_button.dart';
import 'sdk/filter_chip.dart';
import 'sdk/floating_action_button.dart';
import 'sdk/icon_button.dart';
import 'sdk/input_chip.dart';
import 'sdk/input_decorator.dart';
import 'sdk/list_tile.dart';
import 'sdk/menu_anchor.dart';
import 'sdk/navigation_bar.dart';
import 'sdk/navigation_drawer.dart';
import 'sdk/navigation_rail.dart';
import 'sdk/outlined_button.dart';
import 'sdk/popup_menu.dart';
import 'sdk/progress_indicator.dart';
import 'sdk/radio.dart';
import 'sdk/range_slider.dart';
import 'sdk/search_anchor.dart';
import 'sdk/segmented_button.dart';
import 'sdk/slider.dart';
import 'sdk/snack_bar.dart';
import 'sdk/switch.dart';
import 'sdk/tabs.dart';
import 'sdk/text_button.dart';

/// Public, context-aware access to the Material 3 default styles that
/// Flutter's widgets compute in private `_XxxDefaultsM3` classes.
///
/// ```dart
/// final defaults = MaterialDefaults.of(context);
/// final ButtonStyle style = defaults.filledButton;
/// final Color? background = style.backgroundColor?.resolve(<WidgetState>{});
/// ```
///
/// Every member returns a **new** framework object (a [ButtonStyle],
/// [ChipThemeData], [InputDecorationThemeData], …) whose values are computed
/// by the same code the framework runs: the classes were produced by the
/// SDK's `dev/tools/gen_defaults` templates from the Material token data of
/// Flutter [tokenVersion], and verified to be identical to the classes
/// compiled into that framework version.
///
/// The returned objects read `Theme.of(context)` (and, for buttons,
/// `MediaQuery.textScalerOf(context)`) lazily, the first time a property is
/// read. Obtain them inside `build` and do not cache them across theme
/// changes.
///
/// These are the **Material 3** defaults. Widgets use them only when
/// [ThemeData.useMaterial3] is true (the default); see
/// [appliesToCurrentTheme].
@immutable
class MaterialDefaults {
  const MaterialDefaults._(this.context);

  /// Creates a [MaterialDefaults] that resolves against the [Theme] and
  /// [MediaQuery] of [context].
  ///
  /// Calling a member registers a dependency on the inherited [Theme] (and
  /// [MediaQuery] for the button styles), exactly like the widgets do, so a
  /// widget using this in `build` rebuilds when the theme changes.
  factory MaterialDefaults.of(BuildContext context) =>
      MaterialDefaults._(context);

  /// The Flutter framework version whose Material token data (in
  /// `dev/tools/gen_defaults/data`) and generator templates produced these
  /// defaults, e.g. `'3.41.8'`.
  ///
  /// The values are exact for this framework version. Other versions may
  /// compute different defaults; regenerate with `tool/generate.dart`.
  static const String tokenVersion = info.generatedFlutterVersion;

  /// The Flutter framework git revision of [tokenVersion].
  static const String flutterRevision = info.generatedFlutterRevision;

  /// The `version` field(s) declared by the Material token data files the
  /// defaults were generated from (for example `6_1_0`).
  static const List<String> tokenDataVersions = info.generatedTokenDataVersions;

  /// The names of the framework's generated token blocks mirrored by this
  /// package (for example `FilledButton`, `InputDecorator`).
  static const List<String> generatedBlocks = info.generatedBlocks;

  /// The context whose [Theme] and [MediaQuery] the defaults resolve against.
  final BuildContext context;

  /// Whether the widgets under [context] actually use these Material 3
  /// defaults, i.e. whether [ThemeData.useMaterial3] is true.
  bool get appliesToCurrentTheme => Theme.of(context).useMaterial3;

  // ---------------------------------------------------------------- Buttons

  /// Default style of [ElevatedButton] (`ElevatedButton.defaultStyleOf`).
  ButtonStyle get elevatedButton => elevatedButtonDefaults(context);

  /// Default style of [FilledButton].
  ButtonStyle get filledButton => filledButtonDefaults(context);

  /// Default style of [FilledButton.tonal].
  ButtonStyle get filledTonalButton => filledTonalButtonDefaults(context);

  /// Default style of [OutlinedButton].
  ButtonStyle get outlinedButton => outlinedButtonDefaults(context);

  /// Default style of [TextButton].
  ButtonStyle get textButton => textButtonDefaults(context);

  /// Default style of the standard [IconButton].
  ///
  /// [toggleable] matches an [IconButton] whose `isSelected` is non-null.
  ButtonStyle iconButton({bool toggleable = false}) =>
      iconButtonDefaults(context, toggleable);

  /// Default style of [IconButton.filled].
  ///
  /// [toggleable] matches an [IconButton] whose `isSelected` is non-null.
  ButtonStyle filledIconButton({bool toggleable = false}) =>
      filledIconButtonDefaults(context, toggleable);

  /// Default style of [IconButton.filledTonal].
  ///
  /// [toggleable] matches an [IconButton] whose `isSelected` is non-null.
  ButtonStyle filledTonalIconButton({bool toggleable = false}) =>
      filledTonalIconButtonDefaults(context, toggleable);

  /// Default style of [IconButton.outlined].
  ///
  /// [toggleable] matches an [IconButton] whose `isSelected` is non-null.
  ButtonStyle outlinedIconButton({bool toggleable = false}) =>
      outlinedIconButtonDefaults(context, toggleable);

  /// Default style of [MenuItemButton] and [SubmenuButton]
  /// (`MenuItemButton.defaultStyleOf`).
  ButtonStyle get menuButton => menuButtonDefaults(context);

  /// Defaults of the regular [FloatingActionButton] (with a child).
  FloatingActionButtonThemeData get floatingActionButton =>
      fabDefaults(context, 'regular', true);

  /// Defaults of [FloatingActionButton.small] (with a child).
  FloatingActionButtonThemeData get smallFloatingActionButton =>
      fabDefaults(context, 'small', true);

  /// Defaults of [FloatingActionButton.large] (with a child).
  FloatingActionButtonThemeData get largeFloatingActionButton =>
      fabDefaults(context, 'large', true);

  /// Defaults of [FloatingActionButton.extended].
  ///
  /// [hasIcon] matches whether the extended button has an `icon`; it changes
  /// the default [FloatingActionButtonThemeData.extendedPadding].
  FloatingActionButtonThemeData extendedFloatingActionButton({
    bool hasIcon = true,
  }) => fabDefaults(context, 'extended', hasIcon);

  /// Defaults of [SegmentedButton]; the button style is in
  /// [SegmentedButtonThemeData.style].
  SegmentedButtonThemeData get segmentedButton =>
      segmentedButtonDefaults(context);

  // ----------------------------------------------------- Surfaces & content

  /// Defaults of the elevated [Card] (the unnamed constructor).
  CardThemeData get card => cardDefaults(context);

  /// Defaults of [Card.filled].
  CardThemeData get filledCard => filledCardDefaults(context);

  /// Defaults of [Card.outlined].
  CardThemeData get outlinedCard => outlinedCardDefaults(context);

  /// Defaults of [Dialog] and [AlertDialog].
  ///
  /// [SimpleDialog] shares the surface values but styles its title with
  /// `TextTheme.titleLarge` instead of [DialogThemeData.titleTextStyle].
  DialogThemeData get dialog => dialogDefaults(context);

  /// Defaults of [Dialog.fullscreen].
  DialogThemeData get fullscreenDialog => fullscreenDialogDefaults(context);

  /// Defaults of [BottomSheet] (standard and modal).
  BottomSheetThemeData get bottomSheet => bottomSheetDefaults(context);

  /// Defaults of [SnackBar].
  ///
  /// With [floating] false (the default, matching
  /// [SnackBarBehavior.fixed]) the result has no `shape`, because a fixed
  /// snack bar is rectangular; with [floating] true it carries the rounded
  /// token shape and `behavior: SnackBarBehavior.floating`.
  SnackBarThemeData snackBar({bool floating = false}) =>
      snackBarDefaults(context, floating);

  /// Defaults of [MaterialBanner].
  ///
  /// `elevation` is the widget's effective 0.0, not the unused 1.0 of the
  /// framework's private defaults class.
  MaterialBannerThemeData get banner => bannerDefaults(context);

  /// Defaults of [Divider] and [VerticalDivider].
  DividerThemeData get divider => dividerDefaults(context);

  /// Defaults of [ListTile].
  ListTileThemeData get listTile => listTileDefaults(context);

  /// Defaults of [ExpansionTile].
  ExpansionTileThemeData get expansionTile => expansionTileDefaults(context);

  // ------------------------------------------------------------------ Chips

  /// Defaults of [Chip] (and of a [RawChip] without `defaultProperties`).
  ChipThemeData chip({bool enabled = true}) => chipDefaults(context, enabled);

  /// Defaults of [ActionChip], or [ActionChip.elevated] when [elevated].
  ChipThemeData actionChip({bool enabled = true, bool elevated = false}) =>
      actionChipDefaults(context, enabled, elevated);

  /// Defaults of [FilterChip], or [FilterChip.elevated] when [elevated].
  ChipThemeData filterChip({
    bool enabled = true,
    bool selected = false,
    bool elevated = false,
  }) => filterChipDefaults(context, enabled, selected, elevated);

  /// Defaults of [ChoiceChip], or [ChoiceChip.elevated] when [elevated].
  ChipThemeData choiceChip({
    bool enabled = true,
    bool selected = false,
    bool elevated = false,
  }) => choiceChipDefaults(context, enabled, selected, elevated);

  /// Defaults of [InputChip].
  ChipThemeData inputChip({bool enabled = true, bool selected = false}) =>
      inputChipDefaults(context, enabled, selected);

  // ---------------------------------------------------- Inputs & selection

  /// Defaults of [InputDecorator], i.e. of a [TextField]'s decoration.
  InputDecorationThemeData get inputDecoration =>
      inputDecoratorDefaults(context);

  /// Defaults of [Checkbox].
  CheckboxThemeData get checkbox => checkboxDefaults(context);

  /// Defaults of [Radio].
  RadioThemeData get radio => radioDefaults(context);

  /// Defaults of [Switch] (the Material variant; `Switch.adaptive` on Apple
  /// platforms renders a Cupertino switch instead).
  SwitchThemeData get switchTheme => switchDefaults(context);

  /// Defaults of [Slider] with `year2023: false` (the current Material 3
  /// design). A `Slider` left at the framework default `year2023: true` uses
  /// a hand-written legacy class that is not token generated.
  SliderThemeData get slider => sliderDefaults(context);

  /// Defaults of [RangeSlider] with `year2023: false`; see [slider].
  SliderThemeData get rangeSlider => rangeSliderDefaults(context);

  /// Defaults of [SearchBar].
  SearchBarThemeData get searchBar => searchBarDefaults(context);

  /// Defaults of the view opened by [SearchAnchor].
  ///
  /// [fullScreen] must match the anchor's effective `isFullScreen` (by
  /// default true on Android/iOS/Fuchsia, false elsewhere).
  SearchViewThemeData searchView({bool fullScreen = false}) =>
      searchViewDefaults(context, fullScreen);

  /// Defaults of the date pickers ([showDatePicker], [DatePickerDialog],
  /// [showDateRangePicker]). Same object as `DatePickerTheme.defaults`.
  DatePickerThemeData get datePicker => datePickerDefaults(context);

  // ------------------------------------------------------------- Navigation

  /// Defaults of [AppBar].
  ///
  /// `toolbarHeight` is the widget's effective [kToolbarHeight] (56.0), not
  /// the unused token height 64.0 of the framework's private defaults class.
  AppBarThemeData get appBar => appBarDefaults(context);

  /// Defaults of [BottomAppBar].
  BottomAppBarThemeData get bottomAppBar => bottomAppBarDefaults(context);

  /// Defaults of [NavigationBar].
  NavigationBarThemeData get navigationBar => navigationBarDefaults(context);

  /// Defaults of [NavigationRail].
  NavigationRailThemeData get navigationRail => navigationRailDefaults(context);

  /// Defaults of [NavigationDrawer].
  NavigationDrawerThemeData get navigationDrawer =>
      navigationDrawerDefaults(context);

  /// Defaults of [Drawer].
  DrawerThemeData get drawer => drawerDefaults(context);

  /// Defaults of a primary [TabBar].
  ///
  /// [isScrollable] must match [TabBar.isScrollable].
  TabBarThemeData tabBar({bool isScrollable = false}) =>
      primaryTabBarDefaults(context, isScrollable);

  /// Defaults of [TabBar.secondary].
  ///
  /// [isScrollable] must match [TabBar.isScrollable].
  TabBarThemeData secondaryTabBar({bool isScrollable = false}) =>
      secondaryTabBarDefaults(context, isScrollable);

  /// Defaults of the menus opened by [MenuAnchor] and [SubmenuButton].
  MenuStyle get menu => menuDefaults(context);

  /// Defaults of [MenuBar].
  MenuStyle get menuBar => menuBarDefaults(context);

  /// Defaults of the menus shown by [PopupMenuButton] / [showMenu].
  PopupMenuThemeData get popupMenu => popupMenuDefaults(context);

  // --------------------------------------------------------------- Feedback

  /// Defaults of [Badge].
  BadgeThemeData get badge => badgeDefaults(context);

  /// Defaults of [LinearProgressIndicator] with `year2023: false`.
  ProgressIndicatorThemeData get linearProgressIndicator =>
      linearProgressDefaults(context);

  /// Defaults of [CircularProgressIndicator] with `year2023: false`.
  ///
  /// [indeterminate] must match whether the indicator's `value` is null.
  ProgressIndicatorThemeData circularProgressIndicator({
    bool indeterminate = true,
  }) => circularProgressDefaults(context, indeterminate);
}
