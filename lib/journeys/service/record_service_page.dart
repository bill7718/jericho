import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/change_notifier_list.dart';
import 'package:waterloo/waterloo.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';

///
/// Records the items in a service by allowing a user to drag and drop
/// the various items in a service on to the service schedule
///
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
    var acceptedItems = ChangeNotifierList<ServiceItem>();
    final getter = Provider.of<ConfigurationGetter>(context);
    final error = FormError();

    final state = RecordServiceDynamicState();
    ChangeNotifierList<ServiceItem> serviceItems = ChangeNotifierList<ServiceItem>();

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
                        child: DragTarget<ServiceItem>(
                          builder: (context, list, _) {
                            return FilteredList<ServiceItem>(
                                label: filterLabel,
                                items: serviceItems.list,
                                builder: (context, ServiceItem item) {
                                  return DraggableNamedItem(
                                    item: item,
                                    selectOnDrag: true,
                                    actionIcon: Icons.add,
                                    onPressed: () {
                                      acceptedItems.add(item.clone());
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
                            child: DropTargetListView<ServiceItem>(
                          list: acceptedItems,
                          builder: (context, item) {
                            return DraggableNamedItem(
                              item: item,
                              selectOnDrag: false,
                              actionIcon: Icons.delete,
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
                      state.fullServiceContents.clear();
                      for (var i in acceptedItems.list) {
                        state.fullServiceContents.add(i.data);
                      }
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
  List<ServiceItem> get serviceItems;
}

class RecordServiceDynamicState implements RecordServiceStateOutput, StepOutput {
  @override
  final List<Map<String, dynamic>> fullServiceContents;

  RecordServiceDynamicState({this.fullServiceContents = const []});
}

abstract class RecordServiceStateOutput implements StepOutput {
  List<Map<String, dynamic>> get fullServiceContents;
}
