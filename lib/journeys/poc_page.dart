import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

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

  //https://pub.dev/packages/native_pdf_view/example

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    //const url = "https://drive.google.com/file/d/19y6rO1Ck7dQ0aRk5XOGx68mtS3iJyMf-/view?usp=sharing";

    //launch(url, webOnlyWindowName: '_self');


    var pageNumber = 1;
    PdfController controller = PdfController(document: PdfDocument.openAsset('assets/test.pdf'),
      initialPage: pageNumber,
    );


    return PdfView(controller: controller,
      documentLoader: Center(child: CircularProgressIndicator()),
      pageLoader: Center(child: CircularProgressIndicator()),);

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
