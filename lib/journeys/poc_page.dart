import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import 'package:http/http.dart' as http;

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
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'RbD62FUJVik',
      params: const YoutubePlayerParams(

      ),

    );

    print(YoutubePlayerController.getThumbnail(videoId: 'RbD62FUJVik'));

    //return Image.network(YoutubePlayerController.getThumbnail(videoId: 'RbD62FUJVik'));

    Timer(Duration(seconds: 2), () {
      _controller.load('RbD62FUJVik');
    });

    return Container(
        color: Colors.black,
        constraints: BoxConstraints(maxWidth: 800, maxHeight: 450),
        child: LayoutBuilder(
          builder: (context, constraints) {
            print(constraints.maxHeight);
            _controller.setSize(Size(400, 300));
            return YoutubePlayerIFrame(
              controller: _controller,
              aspectRatio: 16 / 9,
            );
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
