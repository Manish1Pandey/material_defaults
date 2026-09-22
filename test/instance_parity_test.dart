// Instance parity: for every component where the framework exposes the
// private defaults object it actually uses, compare ours with it exhaustively.
//
// * ButtonStyleButton.defaultStyleOf is what ButtonStyleButton's state calls
//   in build (for Elevated/Filled/Outlined/Text buttons and the private
//   _IconButtonM3 that IconButton builds in Material 3).
// * MenuItemButton/SubmenuButton.defaultStyleOf is what their TextButton uses.
// * RawChip.defaultProperties is what ActionChip, FilterChip, ChoiceChip and
//   InputChip pass to RawChip.
// * DatePickerTheme.defaults is what the date pickers use.

// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_defaults/material_defaults.dart';

import 'support/parity.dart';

Future<BuildContext> _pump(
  WidgetTester tester,
  ThemeData theme,
  Widget child,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    ),
  );
  return tester.element(find.byWidget(child));
}

/// The ButtonStyleButton that [finder]'s widget builds (itself for the
/// ButtonStyleButton subclasses, the private _IconButtonM3 for IconButton).
Element _buttonStyleButton(WidgetTester tester, Finder finder) {
  return tester.element(
    find
        .descendant(
          of: finder,
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
          matchRoot: true,
        )
        .first,
  );
}

void _checkButton(
  WidgetTester tester, {
  required Finder finder,
  required ButtonStyle Function(MaterialDefaults d) ours,
  required String generatedClass,
}) {
  final element = _buttonStyleButton(tester, finder);
  final widget = element.widget as ButtonStyleButton;
  final theirs = widget.defaultStyleOf(element);
  final mine = ours(MaterialDefaults.of(element));
  expect(
    theirs.runtimeType.toString(),
    '_$generatedClass',
    reason: 'the framework is expected to use $generatedClass here',
  );
  expectFullCoverage('_$generatedClass', mine);
  final comparisons = expectSameDefaults(mine, theirs);
  expect(comparisons, greaterThan(1000));
}

void main() {
  for (final entry in parityThemes.entries) {
    final theme = entry.value;
    group('${entry.key} theme', () {
      testWidgets('ElevatedButton', (tester) async {
        await _pump(
          tester,
          theme,
          ElevatedButton(onPressed: () {}, child: const Text('a')),
        );
        _checkButton(
          tester,
          finder: find.byType(ElevatedButton),
          ours: (d) => d.elevatedButton,
          generatedClass: 'ElevatedButtonDefaultsM3',
        );
      });

      testWidgets('FilledButton', (tester) async {
        await _pump(
          tester,
          theme,
          FilledButton(onPressed: () {}, child: const Text('a')),
        );
        _checkButton(
          tester,
          finder: find.byType(FilledButton),
          ours: (d) => d.filledButton,
          generatedClass: 'FilledButtonDefaultsM3',
        );
      });

      testWidgets('FilledButton.tonal', (tester) async {
        await _pump(
          tester,
          theme,
          FilledButton.tonal(onPressed: () {}, child: const Text('a')),
        );
        _checkButton(
          tester,
          finder: find.byType(FilledButton),
          ours: (d) => d.filledTonalButton,
          generatedClass: 'FilledTonalButtonDefaultsM3',
        );
      });

      testWidgets('OutlinedButton', (tester) async {
        await _pump(
          tester,
          theme,
          OutlinedButton(onPressed: () {}, child: const Text('a')),
        );
        _checkButton(
          tester,
          finder: find.byType(OutlinedButton),
          ours: (d) => d.outlinedButton,
          generatedClass: 'OutlinedButtonDefaultsM3',
        );
      });

      testWidgets('TextButton', (tester) async {
        await _pump(
          tester,
          theme,
          TextButton(onPressed: () {}, child: const Text('a')),
        );
        _checkButton(
          tester,
          finder: find.byType(TextButton),
          ours: (d) => d.textButton,
          generatedClass: 'TextButtonDefaultsM3',
        );
      });

      testWidgets('buttons under 2x text scaling', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: MediaQuery.withClampedTextScaling(
              minScaleFactor: 2,
              maxScaleFactor: 2,
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    ElevatedButton(onPressed: () {}, child: const Text('a')),
                    FilledButton(onPressed: () {}, child: const Text('a')),
                    OutlinedButton(onPressed: () {}, child: const Text('a')),
                    TextButton(onPressed: () {}, child: const Text('a')),
                  ],
                ),
              ),
            ),
          ),
        );
        _checkButton(
          tester,
          finder: find.byType(ElevatedButton),
          ours: (d) => d.elevatedButton,
          generatedClass: 'ElevatedButtonDefaultsM3',
        );
        _checkButton(
          tester,
          finder: find.byType(FilledButton),
          ours: (d) => d.filledButton,
          generatedClass: 'FilledButtonDefaultsM3',
        );
        _checkButton(
          tester,
          finder: find.byType(OutlinedButton),
          ours: (d) => d.outlinedButton,
          generatedClass: 'OutlinedButtonDefaultsM3',
        );
        _checkButton(
          tester,
          finder: find.byType(TextButton),
          ours: (d) => d.textButton,
          generatedClass: 'TextButtonDefaultsM3',
        );
        // Text scaling changes the padding, and ours follows it.
        final padding = MaterialDefaults.of(
          tester.element(find.byType(TextButton)),
        ).textButton.padding!.resolve(<WidgetState>{});
        expect(
          padding,
          isNot(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        );
      });

      for (final toggleable in <bool>[false, true]) {
        final bool? isSelected = toggleable ? true : null;
        testWidgets('IconButton (toggleable: $toggleable)', (tester) async {
          await _pump(
            tester,
            theme,
            IconButton(
              isSelected: isSelected,
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          );
          _checkButton(
            tester,
            finder: find.byType(IconButton),
            ours: (d) => d.iconButton(toggleable: toggleable),
            generatedClass: 'IconButtonDefaultsM3',
          );
        });
        testWidgets('IconButton.filled (toggleable: $toggleable)', (
          tester,
        ) async {
          await _pump(
            tester,
            theme,
            IconButton.filled(
              isSelected: isSelected,
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          );
          _checkButton(
            tester,
            finder: find.byType(IconButton),
            ours: (d) => d.filledIconButton(toggleable: toggleable),
            generatedClass: 'FilledIconButtonDefaultsM3',
          );
        });
        testWidgets('IconButton.filledTonal (toggleable: $toggleable)', (
          tester,
        ) async {
          await _pump(
            tester,
            theme,
            IconButton.filledTonal(
              isSelected: isSelected,
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          );
          _checkButton(
            tester,
            finder: find.byType(IconButton),
            ours: (d) => d.filledTonalIconButton(toggleable: toggleable),
            generatedClass: 'FilledTonalIconButtonDefaultsM3',
          );
        });
        testWidgets('IconButton.outlined (toggleable: $toggleable)', (
          tester,
        ) async {
          await _pump(
            tester,
            theme,
            IconButton.outlined(
              isSelected: isSelected,
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          );
          _checkButton(
            tester,
            finder: find.byType(IconButton),
            ours: (d) => d.outlinedIconButton(toggleable: toggleable),
            generatedClass: 'OutlinedIconButtonDefaultsM3',
          );
        });
      }

      testWidgets('MenuItemButton and SubmenuButton', (tester) async {
        final item = MenuItemButton(onPressed: () {}, child: const Text('a'));
        final context = await _pump(tester, theme, item);
        final mine = MaterialDefaults.of(context).menuButton;
        final theirs = item.defaultStyleOf(context);
        expect(theirs.runtimeType.toString(), '_MenuButtonDefaultsM3');
        expectFullCoverage('_MenuButtonDefaultsM3', mine);
        expect(expectSameDefaults(mine, theirs), greaterThan(1000));
        const submenu = SubmenuButton(
          menuChildren: <Widget>[],
          child: Text('b'),
        );
        expect(
          expectSameDefaults(mine, submenu.defaultStyleOf(context)),
          greaterThan(1000),
        );
      });

      testWidgets('DatePicker', (tester) async {
        final context = await _pump(
          tester,
          theme,
          const SizedBox(width: 10, height: 10),
        );
        final mine = MaterialDefaults.of(context).datePicker;
        final theirs = DatePickerTheme.defaults(context);
        expect(theirs.runtimeType.toString(), '_DatePickerDefaultsM3');
        expectFullCoverage('_DatePickerDefaultsM3', mine);
        expect(expectSameDefaults(mine, theirs), greaterThan(1000));
      });

      group('chips', () {
        ChipThemeData theirs(WidgetTester tester) =>
            tester.widget<RawChip>(find.byType(RawChip)).defaultProperties!;
        MaterialDefaults d(WidgetTester tester) =>
            MaterialDefaults.of(tester.element(find.byType(RawChip)));

        for (final enabled in <bool>[true, false]) {
          final VoidCallback? onPressed = enabled ? () {} : null;
          for (final elevated in <bool>[false, true]) {
            testWidgets('ActionChip enabled=$enabled elevated=$elevated', (
              tester,
            ) async {
              await _pump(
                tester,
                theme,
                elevated
                    ? ActionChip.elevated(
                        label: const Text('a'),
                        onPressed: onPressed,
                      )
                    : ActionChip(label: const Text('a'), onPressed: onPressed),
              );
              final mine = d(
                tester,
              ).actionChip(enabled: enabled, elevated: elevated);
              expect(
                theirs(tester).runtimeType.toString(),
                '_ActionChipDefaultsM3',
              );
              expectFullCoverage('_ActionChipDefaultsM3', mine);
              expect(expectSameDefaults(mine, theirs(tester)), greaterThan(40));
            });
            for (final selected in <bool>[false, true]) {
              final ValueChanged<bool>? onSelected = enabled ? (_) {} : null;
              testWidgets(
                'FilterChip enabled=$enabled selected=$selected elevated=$elevated',
                (tester) async {
                  await _pump(
                    tester,
                    theme,
                    elevated
                        ? FilterChip.elevated(
                            label: const Text('a'),
                            selected: selected,
                            onSelected: onSelected,
                          )
                        : FilterChip(
                            label: const Text('a'),
                            selected: selected,
                            onSelected: onSelected,
                          ),
                  );
                  final mine = d(tester).filterChip(
                    enabled: enabled,
                    selected: selected,
                    elevated: elevated,
                  );
                  expect(
                    theirs(tester).runtimeType.toString(),
                    '_FilterChipDefaultsM3',
                  );
                  expectFullCoverage('_FilterChipDefaultsM3', mine);
                  expect(
                    expectSameDefaults(mine, theirs(tester)),
                    greaterThan(40),
                  );
                },
              );
              testWidgets(
                'ChoiceChip enabled=$enabled selected=$selected elevated=$elevated',
                (tester) async {
                  await _pump(
                    tester,
                    theme,
                    elevated
                        ? ChoiceChip.elevated(
                            label: const Text('a'),
                            selected: selected,
                            onSelected: onSelected,
                          )
                        : ChoiceChip(
                            label: const Text('a'),
                            selected: selected,
                            onSelected: onSelected,
                          ),
                  );
                  final mine = d(tester).choiceChip(
                    enabled: enabled,
                    selected: selected,
                    elevated: elevated,
                  );
                  expect(
                    theirs(tester).runtimeType.toString(),
                    '_ChoiceChipDefaultsM3',
                  );
                  expectFullCoverage('_ChoiceChipDefaultsM3', mine);
                  expect(
                    expectSameDefaults(mine, theirs(tester)),
                    greaterThan(40),
                  );
                },
              );
            }
          }
          for (final selected in <bool>[false, true]) {
            testWidgets('InputChip enabled=$enabled selected=$selected', (
              tester,
            ) async {
              await _pump(
                tester,
                theme,
                InputChip(
                  label: const Text('a'),
                  selected: selected,
                  isEnabled: enabled,
                  onSelected: (_) {},
                ),
              );
              final mine = d(
                tester,
              ).inputChip(enabled: enabled, selected: selected);
              expect(
                theirs(tester).runtimeType.toString(),
                '_InputChipDefaultsM3',
              );
              expectFullCoverage('_InputChipDefaultsM3', mine);
              expect(expectSameDefaults(mine, theirs(tester)), greaterThan(40));
            });
          }
        }
      });
    });
  }
}
