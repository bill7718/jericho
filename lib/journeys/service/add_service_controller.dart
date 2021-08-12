import 'dart:async';
import 'dart:typed_data';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/presentation/record_presentation_page.dart';
import 'package:jericho/journeys/service/record_service_name.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/journeys/you_tube/record_you_tube_page.dart';
import 'package:jericho/services/presentation_services.dart';
import 'package:jericho/services/service_services.dart';
import 'package:jericho/services/you_tube_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
///
class AddServiceController extends UserJourneyController {
  static const String recordServiceRoute = '/recordService';
  static const String recordServiceNameRoute = '/recordServiceName';

  static const String duplicateService = 'duplicateService';

  String _currentRoute = '';
  final AddServiceState _state = AddServiceState();
  final UserJourneyNavigator _navigator;
  final ServiceServices _services;
  final SessionState _session;

  AddServiceController(this._navigator, this._services, this._session);

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
              _currentRoute = recordServiceNameRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for AddServiceController $event');
          }
          break;

        case recordServiceNameRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var o = output as RecordServiceNameStateOutput;
              var checkResponse =
                  await _services.checkService(CheckServiceRequest(_session.organisationId, o.name));
              if (checkResponse.valid) {
                _currentRoute = recordServiceRoute;
                _state.name = o.name;
                _navigator.goTo(context, _currentRoute, this, _state);

              } else {
                _state.messageReference = duplicateService;
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

class AddServiceState implements StepInput, RecordServiceNameStateInput {
  String name = '';
  String messageReference = '';

  List<Map<String, String>> serviceContents = <Map<String, String>>[];
}
