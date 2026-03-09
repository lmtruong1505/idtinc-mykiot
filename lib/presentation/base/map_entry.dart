import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/typography.dart';

import '../constants/spacing.dart';

class MenuEntry {
  const MenuEntry({
    this.label,
    this.labelWidget,
    this.titleColor,
    this.shortcut,
    this.onPressed,
    this.menuChildren,
  }) : assert(
          menuChildren == null || onPressed == null,
          'onPressed is ignored if menuChildren are provided',
        );
  final String? label;
  final Widget? labelWidget;
  final Color? titleColor;
  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    return selections.map<Widget>(buildSelection).toList();
  }

  static Widget buildSelection(MenuEntry selection) {
    if (selection.menuChildren != null) {
      return SubmenuButton(
        style: const ButtonStyle(alignment: Alignment.centerRight),
        menuStyle: MenuStyle(
          minimumSize: const WidgetStatePropertyAll(Size(120, 0)),
          backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          alignment: Alignment.centerRight,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp12)),
          ),
        ),
        menuChildren: MenuEntry.build(selection.menuChildren!),
        child: selection.labelWidget ??
            Text(
              selection.label ?? '',
              style: p5.copyWith(
                color: selection.titleColor,
              ),
            ),
      );
    }
    return MenuItemButton(
      style: const ButtonStyle(alignment: Alignment.centerRight),
      shortcut: selection.shortcut,
      onPressed: selection.onPressed,
      child: selection.labelWidget ?? Text(selection.label ?? ''),
    );
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
    List<MenuEntry> selections,
  ) {
    final Map<MenuSerializableShortcut, Intent> result =
        <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}
