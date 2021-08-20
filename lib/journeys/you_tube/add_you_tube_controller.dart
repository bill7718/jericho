import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/you_tube/record_you_tube_page.dart';
import 'package:jericho/services/you_tube_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
///
class AddYouTubeController extends MappedJourneyController {
  static const String recordYouTubeRoute = '/recordYouTube';

  static const String duplicateYouTube = 'duplicateYouTube';

  @override
  String currentRoute = '';

  final AddYouTubeState _state = AddYouTubeState();
  final YouTubeServices _services;
  final SessionState _session;

  AddYouTubeController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  StepInput get state => _state;

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
    MappedJourneyController.initialRoute: {
      UserJourneyController.initialEvent: MappedJourneyController.goDown + recordYouTubeRoute
    },
    recordYouTubeRoute: {
      UserJourneyController.backEvent: MappedJourneyController.goUp,
      UserJourneyController.nextEvent: handleNextOnRecordYouTube,
    }
  };


  ///
  /// Check that the name is not duplicated and then
  /// create the YouTube reference
  ///
  Future<void> handleNextOnRecordYouTube(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordYouTubeStateOutput;
    var checkResponse =
    await _services.checkYouTube(CheckYouTubeRequest(_session.organisationId, o.name));
    if (checkResponse.valid) {
      await _services.createYouTube(CreateYouTubeRequest(_session.organisationId, o.name, o.videoId));
      navigator.goUp(context);
    } else {
      _state.messageReference = duplicateYouTube;
      _state.name = o.name;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }

}

/// {@macro journeyState}
class AddYouTubeState implements StepInput, RecordYouTubeStateInput {
  @override
  String name = '';
  @override
  String messageReference = '';
  String content = '';
  @override
  String videoId = '';
  String videoIdentifier = '';
}
