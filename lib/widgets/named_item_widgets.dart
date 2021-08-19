import 'package:flutter/material.dart';
import 'package:jericho/general/constants.dart';


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
      leading: Icon(serviceTypeIcons[item.type]),
    );
  }
}

abstract class NamedItem {

  /// Return the name associated with this item
  String get name;

  /// Return the type of the item.
  String get type;
}



class DraggableNamedItem extends StatelessWidget {
  final NamedItem item;
  final bool selectOnDrag;
  final Function? onPressed;
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
