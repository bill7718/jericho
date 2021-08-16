import 'package:flutter/material.dart';

class DraggableNamedItem extends StatelessWidget {
  final NamedItem item;
  final bool selectOnDrag;
  final Function? onPressed;
  final IconData? icon;

  const DraggableNamedItem({Key? key, required this.item, this.selectOnDrag = true, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<NamedItem>(
      data: item,
      child: NamedItemTile(
        item: item,
        onPressed: onPressed,
        icon: icon,
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

class NamedItemTile extends StatelessWidget {
  final NamedItem item;
  final bool selected;
  final bool enabled;
  final Function? onPressed;
  final IconData? icon;

  const NamedItemTile(
      {Key? key, required this.item, this.selected = false, this.enabled = true, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: icon == null
          ? null
          : IconButton(
              icon: Icon(icon),
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
    );
  }
}

abstract class NamedItem {
  String get name;
  String get type;
}
