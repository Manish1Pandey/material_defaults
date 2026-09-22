import 'package:flutter/material.dart';
import 'package:material_defaults/material_defaults.dart';

import 'properties.dart';

void main() => runApp(const DefaultsGalleryApp());

/// Seed colors the gallery can switch between.
const List<Color> seeds = <Color>[
  Color(0xFF6750A4),
  Color(0xFF00696E),
  Color(0xFFB3261E),
  Color(0xFF3F6837),
];

/// Root of the example: a theme switcher around the gallery.
class DefaultsGalleryApp extends StatefulWidget {
  /// Creates the example app.
  const DefaultsGalleryApp({super.key});

  @override
  State<DefaultsGalleryApp> createState() => _DefaultsGalleryAppState();
}

class _DefaultsGalleryAppState extends State<DefaultsGalleryApp> {
  Brightness _brightness = Brightness.light;
  Color _seed = seeds.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'material_defaults',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: _brightness,
        ),
      ),
      home: HomePage(
        brightness: _brightness,
        seed: _seed,
        onBrightnessChanged: (b) => setState(() => _brightness = b),
        onSeedChanged: (c) => setState(() => _seed = c),
      ),
    );
  }
}

/// One component entry in the gallery.
class DefaultsEntry {
  /// Creates an entry named [name] whose defaults are built by [read].
  const DefaultsEntry(this.name, this.read);

  /// Component name shown in the list.
  final String name;

  /// Reads the defaults object from [MaterialDefaults].
  final Object Function(MaterialDefaults d) read;
}

/// Every member of [MaterialDefaults], in gallery order.
final List<DefaultsEntry> entries = <DefaultsEntry>[
  DefaultsEntry('ElevatedButton', (d) => d.elevatedButton),
  DefaultsEntry('FilledButton', (d) => d.filledButton),
  DefaultsEntry('FilledButton.tonal', (d) => d.filledTonalButton),
  DefaultsEntry('OutlinedButton', (d) => d.outlinedButton),
  DefaultsEntry('TextButton', (d) => d.textButton),
  DefaultsEntry('IconButton', (d) => d.iconButton()),
  DefaultsEntry(
    'IconButton (toggleable)',
    (d) => d.iconButton(toggleable: true),
  ),
  DefaultsEntry('IconButton.filled', (d) => d.filledIconButton()),
  DefaultsEntry('IconButton.filledTonal', (d) => d.filledTonalIconButton()),
  DefaultsEntry('IconButton.outlined', (d) => d.outlinedIconButton()),
  DefaultsEntry('MenuItemButton', (d) => d.menuButton),
  DefaultsEntry('FloatingActionButton', (d) => d.floatingActionButton),
  DefaultsEntry(
    'FloatingActionButton.small',
    (d) => d.smallFloatingActionButton,
  ),
  DefaultsEntry(
    'FloatingActionButton.large',
    (d) => d.largeFloatingActionButton,
  ),
  DefaultsEntry(
    'FloatingActionButton.extended',
    (d) => d.extendedFloatingActionButton(),
  ),
  DefaultsEntry('SegmentedButton', (d) => d.segmentedButton),
  DefaultsEntry('Card', (d) => d.card),
  DefaultsEntry('Card.filled', (d) => d.filledCard),
  DefaultsEntry('Card.outlined', (d) => d.outlinedCard),
  DefaultsEntry('Dialog', (d) => d.dialog),
  DefaultsEntry('Dialog.fullscreen', (d) => d.fullscreenDialog),
  DefaultsEntry('BottomSheet', (d) => d.bottomSheet),
  DefaultsEntry('SnackBar (fixed)', (d) => d.snackBar()),
  DefaultsEntry('SnackBar (floating)', (d) => d.snackBar(floating: true)),
  DefaultsEntry('MaterialBanner', (d) => d.banner),
  DefaultsEntry('Divider', (d) => d.divider),
  DefaultsEntry('ListTile', (d) => d.listTile),
  DefaultsEntry('ExpansionTile', (d) => d.expansionTile),
  DefaultsEntry('Chip', (d) => d.chip()),
  DefaultsEntry('ActionChip', (d) => d.actionChip()),
  DefaultsEntry('FilterChip (selected)', (d) => d.filterChip(selected: true)),
  DefaultsEntry('ChoiceChip (selected)', (d) => d.choiceChip(selected: true)),
  DefaultsEntry('InputChip', (d) => d.inputChip()),
  DefaultsEntry('InputDecoration', (d) => d.inputDecoration),
  DefaultsEntry('Checkbox', (d) => d.checkbox),
  DefaultsEntry('Radio', (d) => d.radio),
  DefaultsEntry('Switch', (d) => d.switchTheme),
  DefaultsEntry('Slider (year2023: false)', (d) => d.slider),
  DefaultsEntry('RangeSlider (year2023: false)', (d) => d.rangeSlider),
  DefaultsEntry('SearchBar', (d) => d.searchBar),
  DefaultsEntry('SearchView', (d) => d.searchView()),
  DefaultsEntry('DatePicker', (d) => d.datePicker),
  DefaultsEntry('AppBar', (d) => d.appBar),
  DefaultsEntry('BottomAppBar', (d) => d.bottomAppBar),
  DefaultsEntry('NavigationBar', (d) => d.navigationBar),
  DefaultsEntry('NavigationRail', (d) => d.navigationRail),
  DefaultsEntry('NavigationDrawer', (d) => d.navigationDrawer),
  DefaultsEntry('Drawer', (d) => d.drawer),
  DefaultsEntry('TabBar', (d) => d.tabBar()),
  DefaultsEntry('TabBar.secondary', (d) => d.secondaryTabBar()),
  DefaultsEntry('Menu', (d) => d.menu),
  DefaultsEntry('MenuBar', (d) => d.menuBar),
  DefaultsEntry('PopupMenu', (d) => d.popupMenu),
  DefaultsEntry('Badge', (d) => d.badge),
  DefaultsEntry('LinearProgressIndicator', (d) => d.linearProgressIndicator),
  DefaultsEntry(
    'CircularProgressIndicator',
    (d) => d.circularProgressIndicator(indeterminate: false),
  ),
];

/// The app shell: an app bar with seed/brightness switches and two
/// destinations, the defaults gallery and the custom-widget comparison.
class HomePage extends StatefulWidget {
  /// Creates the home page.
  const HomePage({
    super.key,
    required this.brightness,
    required this.seed,
    required this.onBrightnessChanged,
    required this.onSeedChanged,
  });

  /// Current brightness.
  final Brightness brightness;

  /// Current seed color.
  final Color seed;

  /// Called when the user toggles light/dark.
  final ValueChanged<Brightness> onBrightnessChanged;

  /// Called when the user picks a seed color.
  final ValueChanged<Color> onSeedChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 defaults'),
        actions: <Widget>[
          PopupMenuButton<Color>(
            tooltip: 'Seed color',
            icon: Icon(Icons.palette, color: widget.seed),
            onSelected: widget.onSeedChanged,
            itemBuilder: (_) => <PopupMenuEntry<Color>>[
              for (final c in seeds)
                PopupMenuItem<Color>(
                  value: c,
                  child: Icon(
                    c == widget.seed ? Icons.circle : Icons.circle_outlined,
                    color: c,
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Toggle brightness',
            onPressed: () => widget.onBrightnessChanged(
              widget.brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
            ),
            icon: Icon(
              widget.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: _index == 0 ? const GalleryView() : const CustomWidgetsView(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Gallery'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Custom'),
        ],
      ),
    );
  }
}

/// Every component's defaults, expandable.
class GalleryView extends StatelessWidget {
  /// Creates the gallery.
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(
          'Tokens from Flutter ${MaterialDefaults.tokenVersion} '
          '(token data ${MaterialDefaults.tokenDataVersions.join(', ')})',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        for (final entry in entries) DefaultsTile(entry: entry),
      ],
    );
  }
}

/// Stock widgets next to re-implementations that only use values read from
/// [MaterialDefaults]; each pair should look identical.
class CustomWidgetsView extends StatelessWidget {
  /// Creates the comparison view.
  const CustomWidgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaults = MaterialDefaults.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(
          'Stock widget (left) vs. built from MaterialDefaults (right)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ComparisonRow(
          name: 'filledButton',
          stock: FilledButton(onPressed: () {}, child: const Text('Save')),
          custom: DefaultsPillButton(onPressed: () {}, label: 'Save'),
        ),
        ComparisonRow(
          name: 'filledButton (disabled)',
          stock: const FilledButton(onPressed: null, child: Text('Save')),
          custom: const DefaultsPillButton(onPressed: null, label: 'Save'),
        ),
        const ComparisonRow(
          name: 'card',
          stock: Card(child: SizedBox(width: 120, height: 64)),
          custom: DefaultsCard(child: SizedBox(width: 120, height: 64)),
        ),
        const ComparisonRow(
          name: 'divider',
          stock: SizedBox(width: 120, child: Divider()),
          custom: SizedBox(width: 120, child: DefaultsDivider()),
        ),
        const SizedBox(height: 16),
        Text(
          'Partial override with copyWith',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            // Only the shape changes; colors, overlays and elevations for
            // every state stay the Material defaults.
            FilledButton(
              style: defaults.filledButton.copyWith(
                shape: const WidgetStatePropertyAll<OutlinedBorder>(
                  BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              onPressed: () {},
              child: const Text('Beveled'),
            ),
            OutlinedButton(
              style: defaults.outlinedButton.copyWith(
                side: WidgetStatePropertyAll<BorderSide>(
                  BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () {},
              child: const Text('Thick outline'),
            ),
          ],
        ),
      ],
    );
  }
}

/// A labelled pair of widgets, each in its own [RepaintBoundary] keyed
/// `'$name/stock'` and `'$name/custom'` so they can be captured and compared.
class ComparisonRow extends StatelessWidget {
  /// Creates a comparison row.
  const ComparisonRow({
    super.key,
    required this.name,
    required this.stock,
    required this.custom,
  });

  /// Label, also used in the keys.
  final String name;

  /// The framework widget.
  final Widget stock;

  /// The re-implementation built from [MaterialDefaults].
  final Widget custom;

  @override
  Widget build(BuildContext context) {
    final label = Text(name, style: Theme.of(context).textTheme.labelLarge);
    final pair = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RepaintBoundary(key: ValueKey<String>('$name/stock'), child: stock),
        const SizedBox(width: 24),
        RepaintBoundary(key: ValueKey<String>('$name/custom'), child: custom),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Label above the pair on phone-width screens.
          if (constraints.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[label, const SizedBox(height: 6), pair],
            );
          }
          return Row(
            children: <Widget>[
              SizedBox(width: 170, child: label),
              pair,
            ],
          );
        },
      ),
    );
  }
}

/// A button implemented without ButtonStyleButton: it resolves
/// `MaterialDefaults.of(context).filledButton` for its own [WidgetState]s and
/// lays itself out the way Material buttons do (visual density, tap target).
class DefaultsPillButton extends StatefulWidget {
  /// Creates the button; a null [onPressed] disables it.
  const DefaultsPillButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  /// Called on tap; null disables the button.
  final VoidCallback? onPressed;

  /// Button text.
  final String label;

  @override
  State<DefaultsPillButton> createState() => _DefaultsPillButtonState();
}

class _DefaultsPillButtonState extends State<DefaultsPillButton> {
  final WidgetStatesController _states = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _states.addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _states
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = MaterialDefaults.of(context).filledButton;
    _states.update(WidgetState.disabled, widget.onPressed == null);
    final states = _states.value;
    T? resolve<T>(WidgetStateProperty<T?>? p) => p?.resolve(states);

    final density = style.visualDensity ?? VisualDensity.standard;
    final adjustment = density.baseSizeAdjustment;
    final minimum = resolve(style.minimumSize)!;
    final maximum = resolve(style.maximumSize)!;
    final constraints = density.effectiveConstraints(
      BoxConstraints(
        minWidth: minimum.width,
        minHeight: minimum.height,
        maxWidth: maximum.width,
        maxHeight: maximum.height,
      ),
    );
    final padding = resolve(style.padding)!
        .add(
          EdgeInsets.fromLTRB(
            adjustment.dx < 0 ? 0 : adjustment.dx,
            adjustment.dy,
            adjustment.dx < 0 ? 0 : adjustment.dx,
            adjustment.dy,
          ),
        )
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);
    final tapTarget = switch (style.tapTargetSize) {
      MaterialTapTargetSize.padded => Size(
        kMinInteractiveDimension + adjustment.dx,
        kMinInteractiveDimension + adjustment.dy,
      ),
      _ => Size.zero,
    };
    final foreground = resolve(style.foregroundColor);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: tapTarget.width,
        minHeight: tapTarget.height,
      ),
      child: Align(
        widthFactor: 1,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: constraints,
          child: Material(
            type: MaterialType.button,
            elevation: resolve(style.elevation) ?? 0,
            textStyle: resolve(style.textStyle)?.copyWith(color: foreground),
            shape: resolve(style.shape),
            color: resolve(style.backgroundColor),
            shadowColor: resolve(style.shadowColor),
            surfaceTintColor: resolve(style.surfaceTintColor),
            animationDuration: style.animationDuration ?? kThemeChangeDuration,
            child: InkWell(
              onTap: widget.onPressed,
              statesController: _states,
              overlayColor: style.overlayColor,
              splashFactory: style.splashFactory,
              mouseCursor: resolve(style.mouseCursor),
              customBorder: resolve(style.shape),
              child: Padding(
                padding: padding,
                child: Align(
                  alignment: style.alignment ?? Alignment.center,
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Text(widget.label),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A card built from `MaterialDefaults.of(context).card`.
class DefaultsCard extends StatelessWidget {
  /// Creates the card around [child].
  const DefaultsCard({super.key, required this.child});

  /// Card content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final card = MaterialDefaults.of(context).card;
    return Padding(
      padding: card.margin ?? EdgeInsets.zero,
      child: Material(
        type: MaterialType.card,
        color: card.color,
        shadowColor: card.shadowColor,
        surfaceTintColor: card.surfaceTintColor,
        elevation: card.elevation ?? 0,
        shape: card.shape,
        clipBehavior: card.clipBehavior ?? Clip.none,
        child: child,
      ),
    );
  }
}

/// A horizontal rule built from `MaterialDefaults.of(context).divider`.
class DefaultsDivider extends StatelessWidget {
  /// Creates the divider.
  const DefaultsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = MaterialDefaults.of(context).divider;
    return SizedBox(
      height: divider.space,
      child: Center(
        child: Container(
          height: divider.thickness,
          margin: EdgeInsetsDirectional.only(
            start: divider.indent ?? 0,
            end: divider.endIndent ?? 0,
          ),
          decoration: BoxDecoration(
            borderRadius: divider.radius,
            border: Border(
              bottom: BorderSide(
                color: divider.color!,
                width: divider.thickness!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Expandable view of one defaults object: every property, with colors as
/// swatches and state-dependent values resolved for common states.
class DefaultsTile extends StatelessWidget {
  /// Creates a tile for [entry].
  const DefaultsTile({super.key, required this.entry});

  /// The component shown.
  final DefaultsEntry entry;

  static const Map<String, Set<WidgetState>> _states =
      <String, Set<WidgetState>>{
        'enabled': <WidgetState>{},
        'hovered': <WidgetState>{WidgetState.hovered},
        'pressed': <WidgetState>{WidgetState.pressed},
        'selected': <WidgetState>{WidgetState.selected},
        'disabled': <WidgetState>{WidgetState.disabled},
      };

  @override
  Widget build(BuildContext context) {
    final (type, all) = propertiesOf(entry.read(MaterialDefaults.of(context)))!;
    final props = <MapEntry<String, Object?>>[
      for (final p in all.entries)
        if (p.value != null) p,
    ];
    return ExpansionTile(
      title: Text(entry.name),
      subtitle: Text('$type · ${props.length} properties'),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final p in props)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final name = Text(
                  p.key,
                  style: Theme.of(context).textTheme.labelMedium,
                );
                // Stack name above value on phone-width screens.
                if (constraints.maxWidth < 480) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      name,
                      const SizedBox(height: 2),
                      _valueView(context, p.value),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 180, child: name),
                    Expanded(child: _valueView(context, p.value)),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _valueView(BuildContext context, Object? v) {
    if (v is WidgetStateProperty<Object?>) {
      // Group the states that resolve to the same value.
      final groups = <Object?, List<String>>{};
      for (final s in _states.entries) {
        (groups[v.resolve(s.value)] ??= <String>[]).add(s.key);
      }
      if (groups.length == 1) {
        return _leaf(context, groups.keys.single);
      }
      return Wrap(
        spacing: 16,
        runSpacing: 4,
        children: <Widget>[
          for (final g in groups.entries)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  '${g.value.join(', ')}: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                _leaf(context, g.key),
              ],
            ),
        ],
      );
    }
    return _leaf(context, v);
  }

  Widget _swatch(BuildContext context, Color c) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsetsDirectional.only(end: 4),
      decoration: BoxDecoration(
        color: c,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }

  Widget _leaf(BuildContext context, Object? v) {
    final small = Theme.of(context).textTheme.bodySmall;
    if (v is Color) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _swatch(context, v),
          Flexible(
            child: Text(
              '0x${v.toARGB32().toRadixString(16).padLeft(8, '0')}',
              style: small,
            ),
          ),
        ],
      );
    }
    if (v is TextStyle) {
      final parts = <String>[
        if (v.fontSize != null) 'size ${v.fontSize}',
        if (v.fontWeight != null) 'weight ${v.fontWeight!.value}',
        if (v.height != null) 'height ${v.height}',
        if (v.letterSpacing != null) 'tracking ${v.letterSpacing}',
      ];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (v.color != null) _swatch(context, v.color!),
          Flexible(
            child: Text(
              parts.isEmpty
                  ? 'color only (inherits the rest)'
                  : parts.join(' · '),
              style: small,
            ),
          ),
        ],
      );
    }
    return Text(
      // Drop identity hashes such as `VisualDensity#300aa`.
      '$v'.replaceAll(RegExp(r'#[0-9a-f]{5}\b'), ''),
      style: small,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
