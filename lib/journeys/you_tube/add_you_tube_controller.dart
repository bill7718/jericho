import 'dart:async';
import 'dart:typed_data';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/presentation/record_presentation_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/you_tube/record_you_tube_page.dart';
import 'package:jericho/services/presentation_services.dart';
import 'package:jericho/services/you_tube_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
///
class AddYouTubeController extends UserJourneyController {
  static const String recordYouTubeRoute = '/recordYouTube';

  static const String duplicateYouTube = 'duplicateYouTube';

  String _currentRoute = '';
  final AddYouTubeState _state = AddYouTubeState();
  final UserJourneyNavigator _navigator;
  final YouTubeServices _services;
  final SessionState _session;

  AddYouTubeController(this._navigator, this._services, this._session);

  @override
  String get currentRoute => _currentRoute;

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) async {
    var c = Completer<void>();
    try {
      _state.messageReference = '';

      switch (_currentRoute) {
        case '':
          switch (event) {
            case UserJourneyController.initialEvent:
              _currentRoute = recordYouTubeRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for AddYouTubeController $event');
          }
          break;

        case recordYouTubeRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var o = output as RecordYouTubeStateOutput;
              var checkResponse =
                  await _services.checkYouTube(CheckYouTubeRequest(_session.organisationId, o.name));
              if (checkResponse.valid) {
                await _services.createYouTube(CreateYouTubeRequest(_session.organisationId, o.name, o.videoId));
                _navigator.goUp(context);
              } else {
                _state.messageReference = duplicateYouTube;
                _state.name = o.name;
                _navigator.goTo(context, _currentRoute, this, _state);
              }

              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid event for AddYouTubeController Journey $_currentRoute - $event');
          }

          break;

        default:
          throw UserJourneyException('Invalid current route for AddYouTubeController Journey $_currentRoute');
      }
    } catch (ex) {
      if (ex is UserJourneyException) {
        c.completeError(ex);
      } else {
        c.completeError(UserJourneyException(ex.toString()));
      }
    }
    return c.future;
  }
}

class AddYouTubeState implements StepInput, RecordYouTubeStateInput {
  String name = '';
  String messageReference = '';
  String content = '';
  String videoId = '';
  String videoIdentifier = '';
}
