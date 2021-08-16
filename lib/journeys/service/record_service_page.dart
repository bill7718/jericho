import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/widgets/drop_target_list_view.dart';
import 'package:jericho/widgets/filtered_list.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/change_notifier_list.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';

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
    var acceptedItems = ChangeNotifierList<Item>();
    final getter = Provider.of<ConfigurationGetter>(context);
    final error = FormError();

    final state = RecordServiceDynamicState();
    ChangeNotifierList<Item> serviceItems = ChangeNotifierList<Item>();
    for (var item in i.serviceItems) {
      serviceItems.add((Item(item['name'], item['type'])));
    }

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        child: DragTarget<Item>(
                          builder: (context, list, _) {
                            return FilteredList<Item>(
                                items: serviceItems.list,
                                builder: (context, Item item) {
                                  return DraggableNamedItem(
                                    item: item,
                                    selectOnDrag: true,
                                    icon: Icons.add,
                                    onPressed: () {
                                      acceptedItems.add(Item(item.name, item.type));
                                    },
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
                            child: DropTargetListView<Item>(
                          list: acceptedItems,
                          builder: (context, item) {
                            return DraggableNamedItem(
                              item: item,
                              selectOnDrag: false,
                              icon: Icons.delete,
                              onPressed: () => acceptedItems.remove(item),
                            );
                          },
                        )))
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

abstract class RecordServiceStateInput implements StepInput {
  String get name;
  List<Map<String, dynamic>> get serviceItems;
}

class RecordServiceDynamicState implements RecordServiceStateOutput, StepOutput {
  @override
  final List<Map<String, dynamic>> serviceContents;

  RecordServiceDynamicState({this.serviceContents = const []});
}

abstract class RecordServiceStateOutput implements StepOutput {
  List<Map<String, dynamic>> get serviceContents;
}

abstract class NamedItem {
  String get name;
  String get type;
}

class Item extends Scored implements NamedItem, Clone<Item> {
  static int dummyScore = 1;

  @override
  final String name;
  @override
  final String type;

  int _score = 0;

  Item(this.name, this.type) {
    _score = dummyScore;
    dummyScore++;
  }

  @override
  int score(String filter) {
    return _score;
  }

  @override
  Item clone() {
    return Item(name, type);
  }
}

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
