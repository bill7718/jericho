import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:zefyrka/zefyrka.dart';

///
/// The main Landing Page for the application
///
class POCPage extends StatelessWidget {
  static const String titleRef = 'landingPage';

  static const String inviteButtonTextRef = 'inviteButton';
  static const String createLiturgyButtonTextRef = 'createLiturgyButton';

  static const String inviteToOrganisationEvent = 'inviteUser';
  static const String createLiturgyEvent = 'createLiturgy';

  final EventHandler handler;

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();
    ZefyrController controller = ZefyrController();
    controller.addListener(() {
      var json = controller.document.toJson();
      var i = 1;
    });

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            error: error,
          ),
          ZefyrToolbar.basic(controller: controller,
            hideHeadingStyle: true,
            hideStrikeThrough: true,
            hideCodeBlock: true,
            hideHorizontalRule: true,),
          Card(
              child: ZefyrEditor(
                minHeight: 400,
                controller: controller,
              )),
          ChangeNotifierProvider<ZefyrController>.value(
              value: controller,
              child: Consumer<ZefyrController>(
                  builder: (consumerContext, controller, _) {
                    var spans = <TextSpan>[];

                    for (var node in controller.document.root.children) {
                      spans.addAll(getSpans(node));
                    }

                    return RichText(text: TextSpan(children: spans),);
                  })

          ),
          WaterlooTextButton(
            text: getter.getButtonText(nextButton),
            exceptionHandler: handler.handleException,
            onPressed: () {
              handler.handleEvent(context, event: UserJourneyController.nextEvent);
            },

          )
        ]));
  }

  List<TextSpan> getSpans(Node node) {
    var response = <TextSpan>[];
    if (node is TextNode) {
      if (node.style.contains(NotusAttribute.bold)) {
        response.add(TextSpan(text: node.toPlainText(), style: TextStyle(fontWeight: FontWeight.bold)));
      } else {
        response.add(TextSpan(text: node.toPlainText()));
      }
    } else {
      if (node is LineNode) {
        response.add(TextSpan(text: '\n\n'));
        for (var n in node.children) {
          response.addAll(getSpans(n));
        }
      }
    }

    return response;
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
