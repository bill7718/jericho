import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/exception_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';

///
/// The main Landing Page for the application
///
class ExceptionPage extends StatelessWidget {
  static const String titleRef = 'exceptionPage';

  final Exception ex;
  final StackTrace? st;

  const ExceptionPage(this.ex, {Key? key,  this.st })
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {

    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            text: ex.toString(),
            error: error,
          ),

        ]));
  }
}

abstract class LandingPageStateInput implements StepInput {

}
