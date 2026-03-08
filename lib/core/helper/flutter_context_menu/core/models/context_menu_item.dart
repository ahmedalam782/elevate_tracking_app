import 'package:flutter/material.dart';

import '../../widgets/context_menu_state.dart';
import '../../widgets/context_menu_widget.dart';
import '../../widgets/menu_entry_widget.dart';
import 'context_menu.dart';
import 'context_menu_entry.dart';

/// Represents a selectable item in a context menu.
///
/// The [ContextMenuItem] class is used to define individual items that can be displayed
/// within a context menu. It extends the [ContextMenuEntry] class, providing additional
/// functionality for handling item selection, submenus, and associated values.
///
/// A [ContextMenuItem] can have an associated [value] that can be returned when the item
/// is selected. It can also contain a list of [items] to represent submenus, enabling a
/// hierarchical structure within the context menu.
///
/// When a [ContextMenuItem] is selected, it triggers the [handleItemSelection] method, which
/// determines whether the item has subitems. If it does, it toggles the visibility of
/// the submenu associated with the item. If not, it pops the current context menu and
/// returns the associated [value].
///
/// #### Parameters:
/// - [value] - The value associated with the context menu item.
/// - [items] - The list of subitems associated with the context menu item.
/// - [onSelected] - The callback that is triggered when the context menu item is selected.
///
/// see:
/// - [ContextMenuEntry]
/// - [MenuItem]
/// - [MenuHeader]
/// - [MenuDivider]
///
abstract base class ContextMenuItem<T> extends ContextMenuEntry<T> {
  final T? value;
  final List<ContextMenuEntry<T>>? items;
  final ValueChanged<T?>? onSelected;
  final bool enabled;

  /// If true, clicking a submenu item will close the current menu and open a new one.
  /// If false, the submenu will open as an overlay next to the current menu.
  final bool replaceMenuOnSubmenu;

  const ContextMenuItem({
    this.value,
    this.onSelected,
    this.enabled = true,
    this.replaceMenuOnSubmenu = true,
  }) : items = null;

  const ContextMenuItem.submenu({
    required this.items,
    this.onSelected,
    this.enabled = true,
    this.replaceMenuOnSubmenu = true,
  }) : value = null;

  /// Indicates whether the menu item has subitems.
  ///
  /// Can be used to determine whether the item is a submenu.
  ///
  /// see:
  /// - [MenuItem]
  bool get isSubmenuItem => items != null;

  /// Indicates whether the menu item is using the focus node in a child widget.
  ///
  /// Used internally by the [MenuEntryWidget]
  ///
  /// This is helpful when user want to manually handle focus in the [builder].
  bool get autoHandleFocus => true;

  /// Handles the selection of the context menu item.
  ///
  /// If the item has subitems, it closes the current menu and shows a new menu with submenu items.
  /// Otherwise, it pops the current context menu and returns the [value].
  void handleItemSelection(BuildContext context) {
    if (!enabled) return;
    final menuState = ContextMenuState.of(context);

    if (isSubmenuItem) {
      if (replaceMenuOnSubmenu) {
        // Close current menu and show submenu as a new menu
        _showSubmenuAsNewMenu(context, menuState);
      } else {
        // Toggle submenu as overlay
        _toggleSubmenu(context, menuState);
      }
    } else {
      menuState.setSelectedItem(this);
      if (Navigator.canPop(context)) {
        Navigator.pop(context, value);
      }
    }
    onSelected?.call(value);
    menuState.onItemSelected?.call(value);
  }

  /// Shows the submenu as a new context menu, replacing the current one.
  void _showSubmenuAsNewMenu(BuildContext context, ContextMenuState menuState) {
    final submenuItems = items;
    if (submenuItems == null || submenuItems.isEmpty) return;

    // Get the navigator before popping
    final navigator = Navigator.of(context, rootNavigator: true);

    // Show a new menu with the submenu items at the same position
    final submenu = ContextMenu<T>(
      entries: submenuItems,
      position: menuState.position,
      padding: menuState.padding,
      borderRadius: menuState.borderRadius,
      maxWidth: menuState.maxWidth,
      maxHeight: menuState.maxHeight,
      clipBehavior: menuState.clipBehavior,
      boxDecoration: menuState.boxDecoration,
    );

    final onItemSelectedCallback = menuState.onItemSelected;

    // Pop the current menu first
    if (navigator.canPop()) {
      navigator.pop();
    }

    // Use a post-frame callback to show the new menu after the current one is popped
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuState = ContextMenuState<T>(
        menu: submenu,
        onItemSelected: onItemSelectedCallback,
      );

      navigator.push(
        PageRouteBuilder<T>(
          pageBuilder: (ctx, animation, secondaryAnimation) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
                ContextMenuWidget<T>(menuState: menuState),
              ],
            );
          },
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
        ),
      );
    });
  }

  /// Toggles the visibility of the submenu associated with this menu item (overlay mode).
  void _toggleSubmenu(BuildContext context, ContextMenuState menuState) {
    if (menuState.isSubmenuOpen &&
        menuState.focusedEntry == menuState.selectedItem) {
      menuState.closeSubmenu();
    } else {
      menuState.showSubmenu(context: context, parent: this);
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ContextMenuState menuState, [
    FocusNode focusNode,
  ]);
}
