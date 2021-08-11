import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';

///
/// The main Landing Page for the application
///
class POCPage extends StatelessWidget {
  static const String titleRef = 'landingPage';

  final EventHandler handler;

  //https://pub.dev/packages/native_pdf_view/example

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    var i = 1;
    var items = <NamedItem>[];
    while (i < 10) {
      items.add(Item('Item $i', 'Hello'));
      i++;
    }

    var widgets = <Widget>[];
    for (var item in items) {
      widgets.add(DraggableNamedItem(item: item));
    }

    var acceptedItems = NamedItemList();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: 'Proof Of Concept'),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
                height: constraints.maxHeight * 0.95,
                width: constraints.maxWidth * 0.95,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: constraints.maxWidth * 0.4,
                        child: Card(
                          child: DragTarget<NamedItem>(
                            builder: (context, list, _) {
                              return ListView(
                                children: widgets,
                              );
                            },
                            onWillAccept: (data) => true,
                            onAccept: (data) {
                              acceptedItems.remove(data);
                            },
                          ),
                          margin: EdgeInsets.all(10),
                        )),
                    Container(
                        width: constraints.maxWidth * 0.4,
                        child: Card(
                          child: ChangeNotifierProvider<NamedItemList>.value(
                              value: acceptedItems,
                              child: Consumer<NamedItemList>(
                                builder: (consumerContext, list, _) {
                                  return DragTarget<NamedItem>(
                                    builder: (context, list, _) {
                                      var widgets = <Widget>[];
                                      for (var item in acceptedItems.items) {
                                        widgets.add(DragTarget<NamedItem>(
                                          builder: (context, list, _) {
                                            return DraggableNamedItem(
                                              item: item,
                                              selectOnDrag: false,
                                            );
                                          },
                                          onWillAccept: (data) => true,
                                            onAccept: (data) {
                                              if (acceptedItems.items.contains(data)) {
                                                acceptedItems.add(data, beforeItem: item);
                                              } else {
                                                acceptedItems.add(Item(data.name, data.type), beforeItem: item);
                                              }

                                            }
                                        ));
                                      }
                                      return ListView(
                                        children: widgets,
                                      );
                                    },
                                    onWillAccept: (data) => true,
                                    onAccept: (data) {
                                      acceptedItems.add(Item(data.name, data.type));
                                    },
                                  );
                                },
                              )),
                          margin: EdgeInsets.all(10),
                        )),
                  ],
                )));
          },
        ));
  }
}

class POCEventHandler implements EventHandler {
  const POCEventHandler();

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) {
    var c = Completer<void>();
    c.complete();
    return c.future;
  }

  @override
  void handleException(context, Exception ex, StackTrace? st) {}
}

abstract class NamedItem {
  String get key;
  String get name;
  String get type;
}

class Item implements NamedItem {
  final String name;
  final String type;

  Item(this.name, this.type);

  String get key => name;
}

class DraggableNamedItem extends StatelessWidget {
  final NamedItem item;
  final bool selectOnDrag;

  DraggableNamedItem({Key? key, required this.item, this.selectOnDrag = true});

  @override
  Widget build(BuildContext context) {
    return Draggable<NamedItem>(
      data: item,
      child: NamedItemTile(item: item),
      feedback: Container(width: 200, child: Card(child: NamedItemTile(item: item))),
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

  NamedItemTile({Key? key, required this.item, this.selected = false, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      selected: selected,
      enabled: enabled,
    );
  }
}

class NamedItemList with ChangeNotifier {
  List<NamedItem> items = <NamedItem>[];

  add(NamedItem item, { NamedItem? beforeItem}) {

    if (beforeItem != null) {
      items.remove(item);
      var i = items.lastIndexOf(beforeItem);
      items.insert(i, item);
    } else {
      items.add(item);
    }


    notifyListeners();
  }

  remove(NamedItem item) {
    items.remove(item);
    notifyListeners();
  }
}
