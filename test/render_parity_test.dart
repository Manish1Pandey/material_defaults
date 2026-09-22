// Render parity: for every component whose private defaults object is not
// reachable through a framework API, pump the real widget with the stock
// theme and with our defaults injected as the component theme. Identical
// pixels and render trees across idle/hover/focus/press (or open) states, in
// light and dark, prove the injected values equal the ones the widget uses.
// Each scenario also has a perturbed variant that must render differently.

// `year2023: false` is deprecated-flagged but is the only way to reach the
// token-generated slider/progress defaults, so it is used deliberately.
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';

import 'support/parity.dart';

const Color _magenta = Color(0xFFFF00FF);
const WidgetStatePropertyAll<Color> _magentaAll = WidgetStatePropertyAll<Color>(
  _magenta,
);

typedef _Inject = ThemeData Function(ThemeData base, MaterialDefaults d);

class _Scenario {
  const _Scenario(
    this.name, {
    required this.scene,
    required this.inject,
    required this.perturb,
    this.steps = const <ParityStep>[idle],
    this.settle = true,
  });

  final String name;
  final Widget Function() scene;
  final _Inject inject;
  final _Inject perturb;
  final List<ParityStep> steps;
  final bool settle;
}

List<ParityStep> _interactive(Finder target, {int tabs = 1}) => <ParityStep>[
  idle,
  hover(target),
  tab(tabs),
  press(target),
];

Widget _openButton(String label, void Function(BuildContext context) open) {
  return Builder(
    builder: (BuildContext context) =>
        TextButton(onPressed: () => open(context), child: Text(label)),
  );
}

final List<_Scenario> _scenarios = <_Scenario>[
  // -------------------------------------------------------------- buttons
  _Scenario(
    'common buttons (sanity check for instance parity)',
    scene: () => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        TextButton(onPressed: () {}, child: const Text('Text')),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        const ElevatedButton(onPressed: null, child: Text('Disabled')),
      ],
    ),
    inject: (b, d) => b.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(style: d.elevatedButton),
      filledButtonTheme: FilledButtonThemeData(style: d.filledButton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: d.outlinedButton),
      textButtonTheme: TextButtonThemeData(style: d.textButton),
      iconButtonTheme: IconButtonThemeData(style: d.iconButton()),
    ),
    perturb: (b, d) => b.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: d.elevatedButton.copyWith(backgroundColor: _magentaAll),
      ),
    ),
    steps: _interactive(find.byType(ElevatedButton)),
  ),
  for (final (
        String kind,
        Widget Function() fab,
        FloatingActionButtonThemeData Function(MaterialDefaults) data,
      )
      in <
        (
          String,
          Widget Function(),
          FloatingActionButtonThemeData Function(MaterialDefaults),
        )
      >[
        (
          'regular',
          () => FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          (d) => d.floatingActionButton,
        ),
        (
          'small',
          () => FloatingActionButton.small(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          (d) => d.smallFloatingActionButton,
        ),
        (
          'large',
          () => FloatingActionButton.large(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          (d) => d.largeFloatingActionButton,
        ),
        (
          'extended with icon',
          () => FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create'),
          ),
          (d) => d.extendedFloatingActionButton(),
        ),
        (
          'extended without icon',
          () => FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('Create'),
          ),
          (d) => d.extendedFloatingActionButton(hasIcon: false),
        ),
      ])
    _Scenario(
      'FloatingActionButton $kind',
      scene: fab,
      inject: (b, d) => b.copyWith(floatingActionButtonTheme: data(d)),
      perturb: (b, d) => b.copyWith(
        floatingActionButtonTheme: data(d).copyWith(backgroundColor: _magenta),
      ),
      steps: _interactive(find.byType(FloatingActionButton)),
    ),
  _Scenario(
    'SegmentedButton',
    scene: () => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(
              value: 1,
              label: Text('Day'),
              icon: Icon(Icons.today),
            ),
            ButtonSegment<int>(value: 2, label: Text('Week')),
            ButtonSegment<int>(value: 3, label: Text('Month')),
          ],
          selected: const <int>{1},
          onSelectionChanged: (_) {},
        ),
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(value: 1, label: Text('On')),
            ButtonSegment<int>(value: 2, label: Text('Off')),
          ],
          selected: const <int>{2},
        ),
      ],
    ),
    inject: (b, d) => b.copyWith(segmentedButtonTheme: d.segmentedButton),
    perturb: (b, d) => b.copyWith(
      segmentedButtonTheme: d.segmentedButton.copyWith(
        style: d.segmentedButton.style!.copyWith(backgroundColor: _magentaAll),
      ),
    ),
    steps: _interactive(find.text('Week')),
  ),

  // ------------------------------------------------------------ surfaces
  for (final (
        String kind,
        Widget Function() card,
        CardThemeData Function(MaterialDefaults) data,
      )
      in <
        (String, Widget Function(), CardThemeData Function(MaterialDefaults))
      >[
        (
          'elevated',
          () => const Card(child: SizedBox(width: 160, height: 80)),
          (d) => d.card,
        ),
        (
          'filled',
          () => const Card.filled(child: SizedBox(width: 160, height: 80)),
          (d) => d.filledCard,
        ),
        (
          'outlined',
          () => const Card.outlined(child: SizedBox(width: 160, height: 80)),
          (d) => d.outlinedCard,
        ),
      ])
    _Scenario(
      'Card $kind',
      scene: card,
      inject: (b, d) => b.copyWith(cardTheme: data(d)),
      perturb: (b, d) =>
          b.copyWith(cardTheme: data(d).copyWith(color: _magenta)),
    ),
  _Scenario(
    'AlertDialog',
    scene: () => const AlertDialog(
      icon: Icon(Icons.info),
      title: Text('Title'),
      content: Text('Content of the dialog'),
      actions: <Widget>[TextButton(onPressed: null, child: Text('OK'))],
    ),
    inject: (b, d) => b.copyWith(dialogTheme: d.dialog),
    perturb: (b, d) =>
        b.copyWith(dialogTheme: d.dialog.copyWith(backgroundColor: _magenta)),
  ),
  _Scenario(
    'showDialog (barrier, route)',
    scene: () => _openButton(
      'open',
      (context) => showDialog<void>(
        context: context,
        builder: (_) =>
            const AlertDialog(title: Text('Title'), content: Text('Body')),
      ),
    ),
    inject: (b, d) => b.copyWith(dialogTheme: d.dialog),
    perturb: (b, d) =>
        b.copyWith(dialogTheme: d.dialog.copyWith(barrierColor: _magenta)),
    steps: <ParityStep>[tapAndSettle(find.text('open'))],
  ),
  _Scenario(
    'Dialog.fullscreen',
    scene: () => const SizedBox(
      width: 300,
      height: 300,
      child: Dialog.fullscreen(child: Center(child: Text('Full screen'))),
    ),
    inject: (b, d) => b.copyWith(dialogTheme: d.fullscreenDialog),
    perturb: (b, d) => b.copyWith(
      dialogTheme: d.fullscreenDialog.copyWith(backgroundColor: _magenta),
    ),
  ),
  _Scenario(
    'modal bottom sheet',
    scene: () => _openButton(
      'open',
      (context) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) =>
            const SizedBox(height: 200, child: Center(child: Text('Sheet'))),
      ),
    ),
    inject: (b, d) => b.copyWith(bottomSheetTheme: d.bottomSheet),
    perturb: (b, d) => b.copyWith(
      bottomSheetTheme: d.bottomSheet.copyWith(dragHandleColor: _magenta),
    ),
    steps: <ParityStep>[tapAndSettle(find.text('open'))],
  ),
  _Scenario(
    'standard bottom sheet',
    scene: () => _openButton(
      'open',
      (context) => Scaffold.of(context).showBottomSheet(
        (_) => const SizedBox(
          height: 150,
          width: 600,
          child: Center(child: Text('Sheet')),
        ),
        showDragHandle: true,
      ),
    ),
    inject: (b, d) => b.copyWith(bottomSheetTheme: d.bottomSheet),
    perturb: (b, d) => b.copyWith(
      bottomSheetTheme: d.bottomSheet.copyWith(backgroundColor: _magenta),
    ),
    steps: <ParityStep>[tapAndSettle(find.text('open'))],
  ),
  _Scenario(
    'SnackBar fixed with action and close icon',
    scene: () => _openButton(
      'show',
      (context) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Saved'),
          // SnackBar picks its hit-test behavior from whether
          // snackBarTheme.insetPadding is *set*; pin it so the comparison
          // is about values only.
          hitTestBehavior: HitTestBehavior.opaque,
          showCloseIcon: true,
          action: SnackBarAction(label: 'Undo', onPressed: () {}),
        ),
      ),
    ),
    inject: (b, d) => b.copyWith(snackBarTheme: d.snackBar()),
    perturb: (b, d) => b.copyWith(
      snackBarTheme: d.snackBar().copyWith(backgroundColor: _magenta),
    ),
    steps: <ParityStep>[tapAndSettle(find.text('show'))],
  ),
  _Scenario(
    'SnackBar floating',
    scene: () => _openButton(
      'show',
      (context) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved'),
          behavior: SnackBarBehavior.floating,
          hitTestBehavior: HitTestBehavior.opaque,
        ),
      ),
    ),
    inject: (b, d) => b.copyWith(snackBarTheme: d.snackBar(floating: true)),
    perturb: (b, d) => b.copyWith(
      snackBarTheme: d
          .snackBar(floating: true)
          .copyWith(shape: const StadiumBorder()),
    ),
    steps: <ParityStep>[tapAndSettle(find.text('show'))],
  ),
  _Scenario(
    'MaterialBanner',
    scene: () => const MaterialBanner(
      leading: Icon(Icons.wifi_off),
      content: Text('You are offline'),
      actions: <Widget>[TextButton(onPressed: null, child: Text('Retry'))],
    ),
    inject: (b, d) => b.copyWith(bannerTheme: d.banner),
    perturb: (b, d) =>
        b.copyWith(bannerTheme: d.banner.copyWith(backgroundColor: _magenta)),
  ),
  _Scenario(
    'Divider and VerticalDivider',
    scene: () => const SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          SizedBox(height: 60, child: VerticalDivider()),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(dividerTheme: d.divider),
    perturb: (b, d) =>
        b.copyWith(dividerTheme: d.divider.copyWith(color: _magenta)),
  ),
  _Scenario(
    'ListTile',
    scene: () => SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            selected: true,
            leading: const Icon(Icons.star),
            title: const Text('Selected'),
            onTap: () {},
          ),
          const ListTile(
            enabled: false,
            leading: Icon(Icons.block),
            title: Text('Disabled'),
          ),
          const ListTile(
            isThreeLine: true,
            leading: Text('L'),
            title: Text('Three line'),
            subtitle: Text('Line two\nLine three'),
            trailing: Text('T'),
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(listTileTheme: d.listTile),
    perturb: (b, d) =>
        b.copyWith(listTileTheme: d.listTile.copyWith(iconColor: _magenta)),
    steps: _interactive(find.text('Title')),
  ),
  _Scenario(
    'ExpansionTile',
    scene: () => const SizedBox(
      width: 420,
      child: ExpansionTile(
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        children: <Widget>[ListTile(title: Text('Child'))],
      ),
    ),
    inject: (b, d) => b.copyWith(expansionTileTheme: d.expansionTile),
    perturb: (b, d) => b.copyWith(
      expansionTileTheme: d.expansionTile.copyWith(
        collapsedIconColor: _magenta,
      ),
    ),
    steps: <ParityStep>[
      idle,
      hover(find.text('Title')),
      tapAndSettle(find.text('Title')),
    ],
  ),

  // --------------------------------------------------------------- chips
  _Scenario(
    'Chip',
    scene: () => Chip(
      avatar: const Icon(Icons.face),
      label: const Text('Chip'),
      onDeleted: () {},
    ),
    inject: (b, d) => b.copyWith(chipTheme: d.chip()),
    perturb: (b, d) => b.copyWith(
      chipTheme: d.chip().copyWith(side: const BorderSide(color: _magenta)),
    ),
    steps: <ParityStep>[idle, hover(find.byIcon(Icons.cancel))],
  ),
  _Scenario(
    'RawChip disabled',
    scene: () => const RawChip(isEnabled: false, label: Text('Disabled')),
    inject: (b, d) => b.copyWith(chipTheme: d.chip(enabled: false)),
    perturb: (b, d) => b.copyWith(
      chipTheme: d
          .chip(enabled: false)
          .copyWith(labelStyle: const TextStyle(color: _magenta)),
    ),
  ),

  for (final (
        String name,
        Widget Function() chip,
        ChipThemeData Function(MaterialDefaults) data,
      )
      in <
        (String, Widget Function(), ChipThemeData Function(MaterialDefaults))
      >[
        (
          'ActionChip',
          () => ActionChip(
            avatar: const Icon(Icons.add),
            label: const Text('Act'),
            onPressed: () {},
          ),
          (d) => d.actionChip(),
        ),
        (
          'ActionChip.elevated',
          () => ActionChip.elevated(label: const Text('Act'), onPressed: () {}),
          (d) => d.actionChip(elevated: true),
        ),
        (
          'ActionChip disabled',
          () => const ActionChip(label: Text('Act')),
          (d) => d.actionChip(enabled: false),
        ),
        (
          'FilterChip selected',
          () => FilterChip(
            label: const Text('Filter'),
            selected: true,
            onSelected: (_) {},
          ),
          (d) => d.filterChip(selected: true),
        ),
        (
          'FilterChip unselected',
          () => FilterChip(
            label: const Text('Filter'),
            selected: false,
            onSelected: (_) {},
          ),
          (d) => d.filterChip(),
        ),
        (
          'FilterChip.elevated selected disabled',
          () => const FilterChip.elevated(
            label: Text('Filter'),
            selected: true,
            onSelected: null,
          ),
          (d) => d.filterChip(enabled: false, selected: true, elevated: true),
        ),
        (
          'ChoiceChip selected',
          () => ChoiceChip(
            label: const Text('Choice'),
            selected: true,
            onSelected: (_) {},
          ),
          (d) => d.choiceChip(selected: true),
        ),
        (
          'ChoiceChip unselected',
          () => ChoiceChip(
            label: const Text('Choice'),
            selected: false,
            onSelected: (_) {},
          ),
          (d) => d.choiceChip(),
        ),
        (
          'InputChip selected with delete',
          () => InputChip(
            label: const Text('Input'),
            selected: true,
            onSelected: (_) {},
            onDeleted: () {},
          ),
          (d) => d.inputChip(selected: true),
        ),
        (
          'InputChip unselected',
          () => InputChip(
            label: const Text('Input'),
            onPressed: () {},
            onDeleted: () {},
          ),
          (d) => d.inputChip(),
        ),
      ])
    _Scenario(
      name,
      scene: chip,
      inject: (b, d) => b.copyWith(chipTheme: data(d)),
      perturb: (b, d) => b.copyWith(
        chipTheme: data(d).copyWith(
          labelStyle: const TextStyle(color: _magenta),
          side: const BorderSide(color: _magenta),
        ),
      ),
      // No hover step: RawChip turns its InkWell hoverColor transparent as
      // soon as chipTheme.color is *set*, whatever its value.
      steps: <ParityStep>[idle, tab(), press(find.byType(RawChip))],
    ),

  // ------------------------------------------------- inputs & selection
  _Scenario(
    'InputDecorator via TextField',
    scene: () => const SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Label',
              hintText: 'Hint',
              helperText: 'Helper',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.clear),
            ),
          ),
          TextField(
            decoration: InputDecoration(filled: true, labelText: 'Filled'),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Error',
              errorText: 'Required',
            ),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(filled: true, labelText: 'Disabled'),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Outlined',
              prefixText: r'$',
              suffixText: 'USD',
              counterText: '0/10',
            ),
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(inputDecorationTheme: d.inputDecoration),
    perturb: (b, d) => b.copyWith(
      inputDecorationTheme: d.inputDecoration.copyWith(fillColor: _magenta),
    ),
    steps: <ParityStep>[idle, hover(find.byType(TextField)), tab()],
  ),
  _Scenario(
    'Checkbox',
    scene: () => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(value: true, onChanged: (_) {}),
        Checkbox(value: false, onChanged: (_) {}),
        Checkbox(tristate: true, value: null, onChanged: (_) {}),
        const Checkbox(value: true, onChanged: null),
        const Checkbox(value: false, onChanged: null),
        Checkbox(value: true, isError: true, onChanged: (_) {}),
        Checkbox(value: false, isError: true, onChanged: (_) {}),
      ],
    ),
    inject: (b, d) => b.copyWith(checkboxTheme: d.checkbox),
    perturb: (b, d) =>
        b.copyWith(checkboxTheme: d.checkbox.copyWith(fillColor: _magentaAll)),
    steps: _interactive(find.byType(Checkbox)),
  ),
  _Scenario(
    'Radio',
    scene: () => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioGroup<int>(
          groupValue: 1,
          onChanged: (_) {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Radio<int>(value: 1), Radio<int>(value: 2)],
          ),
        ),
        RadioGroup<int>(
          groupValue: 3,
          onChanged: (_) {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<int>(value: 3, enabled: false),
              Radio<int>(value: 4, enabled: false),
            ],
          ),
        ),
      ],
    ),
    inject: (b, d) => b.copyWith(radioTheme: d.radio),
    perturb: (b, d) =>
        b.copyWith(radioTheme: d.radio.copyWith(fillColor: _magentaAll)),
    steps: _interactive(find.byType(Radio<int>)),
  ),
  _Scenario(
    'Switch',
    scene: () => Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Switch(value: true, onChanged: (_) {}),
        Switch(value: false, onChanged: (_) {}),
        const Switch(value: true, onChanged: null),
        const Switch(value: false, onChanged: null),
      ],
    ),
    inject: (b, d) => b.copyWith(switchTheme: d.switchTheme),
    perturb: (b, d) => b.copyWith(
      switchTheme: d.switchTheme.copyWith(trackColor: _magentaAll),
    ),
    steps: _interactive(find.byType(Switch)),
  ),
  _Scenario(
    'Slider (year2023: false)',
    scene: () => SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slider(year2023: false, value: 0.4, onChanged: (_) {}),
          Slider(
            year2023: false,
            value: 0.6,
            divisions: 5,
            label: '3',
            onChanged: (_) {},
          ),
          const Slider(year2023: false, value: 0.3, onChanged: null),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(sliderTheme: d.slider),
    perturb: (b, d) =>
        b.copyWith(sliderTheme: d.slider.copyWith(activeTrackColor: _magenta)),
    steps: _interactive(find.byType(Slider)),
  ),
  _Scenario(
    'RangeSlider (year2023: false)',
    scene: () => SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RangeSlider(
            year2023: false,
            values: const RangeValues(0.2, 0.7),
            onChanged: (_) {},
          ),
          RangeSlider(
            year2023: false,
            values: const RangeValues(0.2, 0.6),
            divisions: 5,
            onChanged: (_) {},
          ),
          RangeSlider(
            year2023: false,
            values: const RangeValues(0.1, 0.5),
            onChanged: null,
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(sliderTheme: d.rangeSlider),
    perturb: (b, d) => b.copyWith(
      sliderTheme: d.rangeSlider.copyWith(inactiveTrackColor: _magenta),
    ),
    steps: <ParityStep>[idle, hover(find.byType(RangeSlider)), tab()],
  ),
  _Scenario(
    'SearchBar',
    scene: () => const SizedBox(
      width: 420,
      child: SearchBar(
        hintText: 'Search',
        leading: Icon(Icons.search),
        trailing: <Widget>[Icon(Icons.mic)],
      ),
    ),
    inject: (b, d) => b.copyWith(searchBarTheme: d.searchBar),
    perturb: (b, d) => b.copyWith(
      searchBarTheme: d.searchBar.copyWith(backgroundColor: _magentaAll),
    ),
    steps: _interactive(find.byType(SearchBar)),
  ),
  for (final fullScreen in <bool>[false, true])
    _Scenario(
      'SearchAnchor view (isFullScreen: $fullScreen)',
      scene: () => SearchAnchor(
        isFullScreen: fullScreen,
        builder: (context, controller) => IconButton(
          icon: const Icon(Icons.search),
          onPressed: controller.openView,
        ),
        suggestionsBuilder: (context, controller) => const <Widget>[
          ListTile(title: Text('Suggestion')),
        ],
      ),
      inject: (b, d) =>
          b.copyWith(searchViewTheme: d.searchView(fullScreen: fullScreen)),
      perturb: (b, d) => b.copyWith(
        searchViewTheme: d
            .searchView(fullScreen: fullScreen)
            .copyWith(backgroundColor: _magenta),
      ),
      steps: <ParityStep>[tapAndSettle(find.byIcon(Icons.search))],
    ),
  _Scenario(
    'DatePickerDialog',
    scene: () => DatePickerDialog(
      initialDate: DateTime(2026, 9, 22),
      currentDate: DateTime(2026, 9, 10),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ),
    inject: (b, d) => b.copyWith(datePickerTheme: d.datePicker),
    perturb: (b, d) => b.copyWith(
      datePickerTheme: d.datePicker.copyWith(headerBackgroundColor: _magenta),
    ),
    steps: <ParityStep>[idle, hover(find.text('15'))],
  ),

  // ---------------------------------------------------------- navigation
  _Scenario(
    'AppBar (idle and scrolled under)',
    scene: () => SizedBox(
      width: 420,
      height: 320,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text('Title'),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: ListView(
          children: <Widget>[
            for (var i = 0; i < 30; i++) ListTile(title: Text('Row $i')),
          ],
        ),
      ),
    ),
    inject: (b, d) => b.copyWith(appBarTheme: d.appBar),
    perturb: (b, d) =>
        b.copyWith(appBarTheme: d.appBar.copyWith(backgroundColor: _magenta)),
    steps: <ParityStep>[
      idle,
      (tester) async {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
      },
    ],
  ),
  _Scenario(
    'BottomAppBar',
    scene: () => SizedBox(
      width: 420,
      child: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
      ),
    ),
    inject: (b, d) => b.copyWith(bottomAppBarTheme: d.bottomAppBar),
    perturb: (b, d) =>
        b.copyWith(bottomAppBarTheme: d.bottomAppBar.copyWith(color: _magenta)),
  ),
  _Scenario(
    'NavigationBar',
    scene: () => SizedBox(
      width: 420,
      child: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (_) {},
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
            enabled: false,
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(navigationBarTheme: d.navigationBar),
    perturb: (b, d) => b.copyWith(
      navigationBarTheme: d.navigationBar.copyWith(indicatorColor: _magenta),
    ),
    steps: _interactive(find.text('Home')),
  ),
  _Scenario(
    'NavigationRail',
    scene: () => SizedBox(
      height: 400,
      child: NavigationRail(
        selectedIndex: 0,
        labelType: NavigationRailLabelType.all,
        onDestinationSelected: (_) {},
        destinations: const <NavigationRailDestination>[
          NavigationRailDestination(
            icon: Icon(Icons.home),
            label: Text('Home'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.search),
            label: Text('Search'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person),
            label: Text('Profile'),
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(navigationRailTheme: d.navigationRail),
    perturb: (b, d) => b.copyWith(
      navigationRailTheme: d.navigationRail.copyWith(indicatorColor: _magenta),
    ),
    steps: _interactive(find.text('Search')),
  ),
  _Scenario(
    'NavigationDrawer',
    scene: () => SizedBox(
      height: 400,
      child: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        children: const <Widget>[
          Padding(padding: EdgeInsets.all(16), child: Text('Header')),
          NavigationDrawerDestination(
            icon: Icon(Icons.inbox),
            label: Text('Inbox'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.send),
            label: Text('Sent'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.delete),
            label: Text('Trash'),
            enabled: false,
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(navigationDrawerTheme: d.navigationDrawer),
    perturb: (b, d) => b.copyWith(
      navigationDrawerTheme: d.navigationDrawer.copyWith(
        indicatorColor: _magenta,
      ),
    ),
    steps: _interactive(find.text('Sent')),
  ),
  _Scenario(
    'Drawer',
    scene: () => const SizedBox(
      height: 400,
      child: Drawer(child: Center(child: Text('Drawer'))),
    ),
    inject: (b, d) => b.copyWith(drawerTheme: d.drawer),
    perturb: (b, d) =>
        b.copyWith(drawerTheme: d.drawer.copyWith(backgroundColor: _magenta)),
  ),
  for (final (String kind, bool secondary, bool scrollable)
      in <(String, bool, bool)>[
        ('primary', false, false),
        ('primary scrollable', false, true),
        ('secondary', true, false),
        ('secondary scrollable', true, true),
      ])
    _Scenario(
      'TabBar $kind',
      scene: () {
        const tabs = <Widget>[
          Tab(icon: Icon(Icons.flight), text: 'Flights'),
          Tab(icon: Icon(Icons.train), text: 'Trains'),
          Tab(icon: Icon(Icons.hotel), text: 'Hotels'),
        ];
        return DefaultTabController(
          length: 3,
          child: SizedBox(
            width: 420,
            child: secondary
                ? TabBar.secondary(isScrollable: scrollable, tabs: tabs)
                : TabBar(isScrollable: scrollable, tabs: tabs),
          ),
        );
      },
      inject: (b, d) => b.copyWith(
        tabBarTheme: secondary
            ? d.secondaryTabBar(isScrollable: scrollable)
            : d.tabBar(isScrollable: scrollable),
      ),
      perturb: (b, d) => b.copyWith(
        tabBarTheme:
            (secondary
                    ? d.secondaryTabBar(isScrollable: scrollable)
                    : d.tabBar(isScrollable: scrollable))
                .copyWith(labelColor: _magenta),
      ),
      // Focus the unselected 'Trains' tab: for the *selected* tab the widget
      // adds WidgetState.selected before resolving the defaults' overlay
      // (covered separately below).
      steps: _interactive(find.text('Trains'), tabs: 2),
    ),
  for (final secondary in <bool>[false, true])
    _Scenario(
      'TabBar ${secondary ? 'secondary' : 'primary'} selected-tab focus overlay',
      scene: () => DefaultTabController(
        length: 2,
        child: SizedBox(
          width: 420,
          child: secondary
              ? const TabBar.secondary(
                  tabs: <Widget>[
                    Tab(text: 'One'),
                    Tab(text: 'Two'),
                  ],
                )
              : const TabBar(
                  tabs: <Widget>[
                    Tab(text: 'One'),
                    Tab(text: 'Two'),
                  ],
                ),
        ),
      ),
      // TabBar resolves the defaults' overlayColor with WidgetState.selected
      // added for the selected tab; a theme overlay is resolved as given.
      inject: (b, d) {
        final TabBarThemeData t = secondary ? d.secondaryTabBar() : d.tabBar();
        return b.copyWith(
          tabBarTheme: t.copyWith(
            overlayColor: WidgetStateProperty.resolveWith(
              (Set<WidgetState> s) => t.overlayColor!.resolve(<WidgetState>{
                ...s,
                WidgetState.selected,
              }),
            ),
          ),
        );
      },
      perturb: (b, d) => b.copyWith(
        tabBarTheme: (secondary ? d.secondaryTabBar() : d.tabBar()).copyWith(
          overlayColor: _magentaAll,
        ),
      ),
      steps: <ParityStep>[idle, tab()],
    ),
  _Scenario(
    'MenuAnchor menu and MenuItemButton',
    scene: () => MenuAnchor(
      menuChildren: <Widget>[
        MenuItemButton(
          leadingIcon: const Icon(Icons.copy),
          onPressed: () {},
          child: const Text('Copy'),
        ),
        const MenuItemButton(child: Text('Disabled')),
        SubmenuButton(
          menuChildren: <Widget>[
            MenuItemButton(onPressed: () {}, child: const Text('Nested')),
          ],
          child: const Text('More'),
        ),
      ],
      builder: (context, controller, child) =>
          TextButton(onPressed: controller.open, child: const Text('menu')),
    ),
    inject: (b, d) => b.copyWith(
      menuTheme: MenuThemeData(style: d.menu),
      menuButtonTheme: MenuButtonThemeData(style: d.menuButton),
    ),
    perturb: (b, d) => b.copyWith(
      menuTheme: MenuThemeData(
        style: d.menu.copyWith(backgroundColor: _magentaAll),
      ),
    ),
    steps: <ParityStep>[
      tapAndSettle(find.text('menu')),
      hover(find.text('Copy')),
      tapAndSettle(find.text('More')),
    ],
  ),
  _Scenario(
    'MenuBar',
    scene: () => SizedBox(
      width: 420,
      child: MenuBar(
        children: <Widget>[
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(onPressed: () {}, child: const Text('New')),
            ],
            child: const Text('File'),
          ),
          SubmenuButton(
            menuChildren: <Widget>[
              MenuItemButton(onPressed: () {}, child: const Text('Undo')),
            ],
            child: const Text('Edit'),
          ),
        ],
      ),
    ),
    inject: (b, d) => b.copyWith(
      menuBarTheme: MenuBarThemeData(style: d.menuBar),
      menuTheme: MenuThemeData(style: d.menu),
      menuButtonTheme: MenuButtonThemeData(style: d.menuButton),
    ),
    perturb: (b, d) => b.copyWith(
      menuBarTheme: MenuBarThemeData(
        style: d.menuBar.copyWith(backgroundColor: _magentaAll),
      ),
    ),
    steps: <ParityStep>[idle, tapAndSettle(find.text('File'))],
  ),
  _Scenario(
    'PopupMenuButton menu',
    scene: () => PopupMenuButton<int>(
      itemBuilder: (_) => const <PopupMenuEntry<int>>[
        PopupMenuItem<int>(value: 1, child: Text('One')),
        CheckedPopupMenuItem<int>(value: 2, checked: true, child: Text('Two')),
        PopupMenuDivider(),
        PopupMenuItem<int>(value: 3, enabled: false, child: Text('Three')),
      ],
    ),
    inject: (b, d) => b.copyWith(popupMenuTheme: d.popupMenu),
    perturb: (b, d) =>
        b.copyWith(popupMenuTheme: d.popupMenu.copyWith(color: _magenta)),
    steps: <ParityStep>[
      tapAndSettle(find.byType(PopupMenuButton<int>)),
      hover(find.text('One')),
    ],
  ),

  // ------------------------------------------------------------ feedback
  _Scenario(
    'Badge',
    scene: () => const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Badge(label: Text('3'), child: Icon(Icons.mail)),
        SizedBox(width: 24),
        Badge(child: Icon(Icons.mail)),
        SizedBox(width: 24),
        Badge(label: Text('999+'), child: Icon(Icons.mail)),
      ],
    ),
    inject: (b, d) => b.copyWith(badgeTheme: d.badge),
    perturb: (b, d) =>
        b.copyWith(badgeTheme: d.badge.copyWith(backgroundColor: _magenta)),
  ),
  _Scenario(
    'LinearProgressIndicator (year2023: false)',
    scene: () => const SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(year2023: false, value: 0.4),
          SizedBox(height: 24),
          LinearProgressIndicator(year2023: false),
        ],
      ),
    ),
    inject: (b, d) =>
        b.copyWith(progressIndicatorTheme: d.linearProgressIndicator),
    perturb: (b, d) => b.copyWith(
      progressIndicatorTheme: d.linearProgressIndicator.copyWith(
        color: _magenta,
      ),
    ),
    settle: false,
    steps: <ParityStep>[
      advance(const Duration(milliseconds: 300)),
      advance(const Duration(milliseconds: 700)),
    ],
  ),
  for (final indeterminate in <bool>[false, true])
    _Scenario(
      'CircularProgressIndicator (year2023: false, indeterminate: $indeterminate)',
      scene: () => CircularProgressIndicator(
        year2023: false,
        value: indeterminate ? null : 0.6,
      ),
      inject: (b, d) => b.copyWith(
        progressIndicatorTheme: d.circularProgressIndicator(
          indeterminate: indeterminate,
        ),
      ),
      perturb: (b, d) => b.copyWith(
        progressIndicatorTheme: d
            .circularProgressIndicator(indeterminate: indeterminate)
            .copyWith(color: _magenta),
      ),
      settle: false,
      steps: <ParityStep>[
        advance(const Duration(milliseconds: 300)),
        advance(const Duration(milliseconds: 700)),
      ],
    ),
];

void main() {
  for (final entry in parityThemes.entries) {
    group('${entry.key} theme', () {
      for (final scenario in _scenarios) {
        testWidgets(scenario.name, (tester) async {
          await expectRenderParity(
            tester,
            theme: entry.value,
            scene: scenario.scene,
            inject: scenario.inject,
            perturb: scenario.perturb,
            steps: scenario.steps,
            settle: scenario.settle,
          );
        });
      }
    });
  }
}
