import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/change_notifier_list.dart';

///
/// Displays a list of items.
///
/// If a [Draggable] widget is dropped on to the list the corresponding item is added to the end of the list
///
/// if a [Draggable] widget is dropped on to one of the items in the list then the corresponding item is inserted into the list
/// before the targeted item.
///
/// If an item is added to the list (or removed from the list) from outside this widget then the list view is redrawn to include the added item
///
class DropTargetListView<T extends Clone<T>> extends StatelessWidget {

  ///
  /// The list of items wrapped in a [ChangeNotifier] so that the Widget can respond to changes from outside this widget
  ///
  final ChangeNotifierList<T> list;

  ///
  /// Builds a widget for each individual item in the list
  ///
  final Function builder;

  const DropTargetListView({Key? key, required this.list, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierList<T>>.value(
        value: list,
        child: Consumer<ChangeNotifierList<T>>(
          builder: (context, l, _) {
            return DragTarget<T>(
              builder: (context, l2, _) {
                var widgets = <Widget>[];
                for (var item in list.list) {
                  widgets.add(DragTarget<T>(
                      builder: (context, l3, _) {
                        return builder(context, item);
                      },
                      onWillAccept: (data) => (data is T),
                      onAccept: (data) {
                        if (list.list.contains(data)) {
                          list.add(data, beforeItem: item);
                        } else {
                          list.add(data.clone(), beforeItem: item);
                        }
                      }));
                }
                return Column(children: [
                  Expanded(
                      flex: 8,
                      child: ListView(
                        children: widgets,
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  )
                ]);
              },
              onWillAccept: (data) => true,
              onAccept: (data) {
                list.add(data.clone());
              },
            );
          },
        ));
  }
}


abstract class Clone<T> {
  /// Returns a clone of this Object
  T clone();
}