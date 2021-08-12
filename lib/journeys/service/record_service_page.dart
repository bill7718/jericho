import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:waterloo/waterloo_text_field.dart';

class RecordServicePage extends StatelessWidget {
  static const String titleRef = 'recordServicePage';
  static const String typeLabel = 'type';
  static const String nameLabel = 'name';

  static const String filterLabel = 'filter';

  final dynamic inputState;
  final EventHandler eventHandler;

  const RecordServicePage({Key? key, required this.inputState, required this.eventHandler})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final i = inputState as RecordServiceStateInput;
    var acceptedItems = NamedItemList();
    final getter = Provider.of<ConfigurationGetter>(context);
    final error = FormError();

    final state = RecordServiceDynamicState();
    final serviceItems = NamedItemList();
    for (var item in i.items) {
      serviceItems.add((Item(item[nameLabel], item[typeLabel])));
    }

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaterlooFormMessage(error: error),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 2,
                        child: DragTarget<NamedItem>(
                          builder: (context, list, _) {
                            return FilteredList<NamedItem>(items: serviceItems.items, widgetBuilder: ( item) {
                              return DraggableNamedItem(
                                item: item,
                                selectOnDrag: true,
                              );
                            });
                          },
                          onWillAccept: (data) => true,
                          onAccept: (data) {
                            acceptedItems.remove(data);
                          },
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                        flex: 2,
                        child: Card(
                            child: ChangeNotifierProvider<NamedItemList>.value(
                                value: acceptedItems,
                                child: Consumer<NamedItemList>(
                                  builder: (context, list, _) {
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
                                        acceptedItems.add(Item(data.name, data.type));
                                      },
                                    );
                                  },
                                ))))
                  ],
                ),
              ),
              WaterlooButtonRow(children: <Widget>[
                WaterlooTextButton(
                  text: getter.getButtonText(previousButton),
                  exceptionHandler: eventHandler.handleException,
                  onPressed: () => eventHandler.handleEvent(context, event: UserJourneyController.backEvent),
                ),
                WaterlooTextButton(
                    text: getter.getButtonText(nextButton),
                    exceptionHandler: eventHandler.handleException,
                    onPressed: () {
                      //TODO pass outcome to the next event
                      eventHandler.handleEvent(context, event: UserJourneyController.nextEvent, output: state);
                    })
              ])
            ],
          ),
        ));
  }
}

class RecordServiceStateInput implements StepInput {
  final String name;
  final List<Map<String, dynamic>> items;

  RecordServiceStateInput({this.name = '', this.items = const []});
}

class RecordServiceDynamicState implements RecordServiceStateOutput, StepOutput {
  final List<Map<String, dynamic>> items;

  RecordServiceDynamicState({this.items = const []});
}

abstract class RecordServiceStateOutput implements StepOutput {
  List<Map<String, dynamic>> get items;
}

class NamedItemList with ChangeNotifier {
  List<NamedItem> items = <NamedItem>[];

  List<NamedItem> filteredItems = <NamedItem>[];

  String _filter = '';

  String get filter => _filter;

  setFilter(String f) {
    if (f != _filter) {
      _filter = f;
      notifyListeners();
    }
  }

  add(NamedItem item, {NamedItem? beforeItem}) {
    if (beforeItem != null) {
      items.remove(item);
      filteredItems.remove(item);
      var i = items.lastIndexOf(beforeItem);
      items.insert(i, item);
      var fi = filteredItems.lastIndexOf(beforeItem);
      if (fi > -1) {
        filteredItems.insert(i, item);
      } else {
        filteredItems.add(item);
      }
    } else {
      items.add(item);
      filteredItems.add(item);
    }

    notifyListeners();
  }

  remove(NamedItem item) {
    items.remove(item);
    notifyListeners();
  }
}

abstract class NamedItem extends Filterable {
  String get key;
  String get name;
  String get type;
}

class Item extends Filterable implements NamedItem {
  static int dummyScore = 1;

  final String name;
  final String type;

  int _score = 0;

  Item(this.name, this.type) {
    _score = dummyScore;
    dummyScore++;
  }

  String get key => name;

  @override
  int score(String filter) {
    return _score;
  }
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
      shape: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      selected: selected,
      enabled: enabled,
      dense: true,
    );
  }
}

abstract class Filterable {
  int score(String filter);
}

class FilteredList<T extends Filterable> extends StatelessWidget {
  final List<T> items;
  final Function widgetBuilder;
  final filterValue = FilterValue();
  static const String filterLabel = 'Filter';

  FilteredList({Key? key, required this.items, required this.widgetBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WaterlooTextField(valueBinder: filterValue.setFilter, label: filterLabel, validator: (v) {}),
        Expanded(
            child: ChangeNotifierProvider<FilterValue>.value(
                value: filterValue,
                child: Consumer<FilterValue>(builder: (context, filterValue, _) {
                  var filteredItems = <T>[];
                  for (var item in items) {
                    if (item.score(filterValue.filter) > 0) {
                      filteredItems.add(item);
                    }
                  }
                  filteredItems.sort((a, b) {
                    if (a.score(filterValue.filter) > b.score(filterValue.filter)) {
                      return -1;
                    } else {
                      return 1;
                    }
                  });

                  var widgets = <Widget>[];
                  for (var item in filteredItems) {
                    widgets.add(widgetBuilder(item));
                  }

                  return Card(
                      child: ListView(
                    children: widgets,
                  ));
                })))
      ],
    );
  }
}

class FilterValue with ChangeNotifier {
  String _filter = '';

  String get filter => _filter;

  setFilter(String f) {
    if (f != filter) {
      _filter = f;
      notifyListeners();
    }
  }
}
