

import 'dart:async';
import 'dart:typed_data';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/presentation/record_presentation_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';


import 'package:jericho/services/presentation_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
///
class AddPresentationController extends UserJourneyController {

  static const String recordPresentationRoute = '/recordPresentation';

  static const String duplicatePresentation = 'duplicatePresentation';

  String _currentRoute = '';
  final AddPresentationState _state = AddPresentationState();
  final UserJourneyNavigator _navigator;
  final PresentationServices _services;
  final SessionState _session;

  AddPresentationController(this._navigator, this._services, this._session);

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
              _currentRoute = recordPresentationRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for AddPresentationController $event');
          }
          break;

        case recordPresentationRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var o = output as RecordPresentationStateOutput;
              var checkResponse =
                  await _services.checkPresentation(CheckPresentationRequest(_session.organisationId, o.name));
              if (checkResponse.valid) {
                await _services.createPresentation(CreatePresentationRequest(_session.organisationId, o.name, o.data));
                _navigator.goUp(context);
              } else {
                _state.messageReference = duplicatePresentation;
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
              throw UserJourneyException('Invalid event for AddPresentationController Journey $_currentRoute - $event');
          }

          break;

        default:
          throw UserJourneyException('Invalid current route for AddPresentationController Journey $_currentRoute');
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

class AddPresentationState implements StepInput, RecordPresentationStateInput {
  @override
  String name = '';
  @override
  String messageReference = '';
  String content = '';
  Uint8List data = Uint8List(0);
}
