import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
//import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

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
    var items = <NameProvider>[];
    while (i < 10) {
      items.add(Item('Item $i', 'Hello'));
      i++;
    }

    return Scaffold(
        appBar: WaterlooAppBar.get(title: 'Proof Of Concept'),
        body: Row(children: [
          Container(padding: EdgeInsets.fromLTRB(50, 10, 25, 0), child: DragFromColumn(items: items)),
          Container(height: 300, width: 100, color: Colors.grey, padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
              child: DragTarget<NameProvider> (builder: (context, list, i) {
                return DragToList();
              },
              onAccept: (item) { print(item.name); }),

          )
        ]));

    return DragFromColumn(items: items);

    return Container();
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

class DragFromColumn extends StatelessWidget {
  final List<NameProvider> items;

  DragFromColumn({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    for (var item in items) {
      widgets.add(Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(10),
          color: Colors.grey,
          child: Draggable<NameProvider>(
            child: Text(item.name),
            feedback: Container(
                color: Colors.grey,
                padding: EdgeInsets.all(10),
                child: Text(
                  item.name,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                )),
            onDragCompleted: () {
              print(item.name);
            },
          )));
    }

    return Column(
      children: widgets,
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}

abstract class NameProvider {
  String get name;
  String get type;
}

class Item implements NameProvider {
  final String name;
  final String type;

  Item(this.name, this.type);
}

class DragToList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = NameProviderList();

    return ChangeNotifierProvider<NameProviderList>.value(
        value: data,
        child: Consumer<NameProviderList>(builder: (context, list, _) {
          var widgets = <Widget>[];
          for (var item in list.items) {
            widgets.add(Text(item.name));
          }

          return Column(
            children: widgets,
          );
        }));
  }
}

class NameProviderList with ChangeNotifier {
  List<NameProvider> items = <NameProvider>[];

  addItem(NameProvider item) {
    items.add(Item(item.name, item.type));
    notifyListeners();
  }
}
