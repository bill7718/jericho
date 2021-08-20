import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';
import 'widgets_vm.dart';

///
/// Wraps a [ListTile] that accepts a [NamedItem] object.
///
/// Includes an [IconButton] and a separate [Icon] that shows the type.
///
class NamedItemTile extends StatelessWidget {
  /// The item
  final NamedItem item;

  /// Set to true to indicate that this widget has been selected
  final bool selected;

  /// Set to false to indicate that this item is selected for removal
  final bool enabled;

  /// Called when the [actionIcon] button is pressed
  final Function? onPressed;

  /// A button that
  final IconData? actionIcon;

  const NamedItemTile(
      {Key? key, required this.item, this.selected = false, this.enabled = true, this.onPressed, this.actionIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: actionIcon == null
          ? null
          : IconButton(
              icon: Icon(actionIcon),
              onPressed: () {
                if (onPressed != null) {
                  onPressed!();
                }
              },
            ),
      title: Text(item.name),
      shape: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      selected: selected,
      enabled: enabled,
      dense: true,
      leading: serviceTypeIcons[item.type] != null ? Icon(serviceTypeIcons[item.type]) : null,
    );
  }
}



///
/// A wrapper around [NamedItemTile] put inside a [Draggable]
///
class DraggableNamedItem extends StatelessWidget {

  /// Contains the the nam and type of the item to be displayed on this Widget
  final NamedItem item;

  /// If true the system shows the
  final bool selectOnDrag;

  /// The function called when the Icon Button is clicked
  final Function? onPressed;

  /// The icon to show as the Icon Button
  final IconData? actionIcon;

  const DraggableNamedItem({Key? key, required this.item, this.selectOnDrag = true, this.onPressed, this.actionIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<NamedItem>(
      data: item,
      child: NamedItemTile(
        item: item,
        onPressed: onPressed,
        actionIcon: actionIcon,
      ),
      feedback: SizedBox(width: 200, child: Card(child: NamedItemTile(item: item))),
      childWhenDragging: NamedItemTile(
        item: item,
        selected: selectOnDrag,
        enabled: selectOnDrag,
      ),
    );
  }
}
