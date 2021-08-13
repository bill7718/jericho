import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_content_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';


///
/// Controls the flow of control when a user wants to Add a new Liturgy item
///
///
class AddLiturgyController extends UserJourneyController {
  static const String recordLiturgyNameRoute = '/recordLiturgyName';
  static const String recordLiturgyContentRoute = '/recordLiturgyContent';
  static const String previewLiturgyRoute = '/previewLiturgy';

  static const String duplicateLiturgy = 'duplicateLiturgy';

  String _currentRoute = '';
  final AddLiturgyState _state = AddLiturgyState();
  final UserJourneyNavigator _navigator;
  final LiturgyServices _services;
  final SessionState _session;

  AddLiturgyController(this._navigator, this._services, this._session);

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
              _currentRoute = recordLiturgyNameRoute;
              _navigator.goDownTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid Event for AddLiturgyController $event');
          }
          break;

        case recordLiturgyNameRoute:
          switch (event) {
            case UserJourneyController.nextEvent:
              var o = output as RecordLiturgyNameStateOutput;
              _state.name = o.name;
              var response = await _services.getLiturgy(GetLiturgyRequest(organisationId: _session.organisationId, name: o.name));
              if (response.valid) {
                // a liturgy with this name is found
                _state.messageReference = duplicateLiturgy;
                _navigator.goTo(context, _currentRoute, this, _state);
              } else {
                _currentRoute = recordLiturgyContentRoute;
                _navigator.goTo(context, _currentRoute, this, _state);
              }
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid event for AddLiturgy Journey $_currentRoute - $event');
          }

          break;

        case recordLiturgyContentRoute:

          switch (event) {
            case UserJourneyController.nextEvent:
              var o = output as RecordLiturgyContentStateOutput;
              _state.content = o.content;
              _currentRoute = previewLiturgyRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _currentRoute = recordLiturgyNameRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            case UserJourneyController.cancelEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid event for AddLiturgy Journey $_currentRoute - $event');
          }
          break;

        case previewLiturgyRoute:

          switch (event) {
            case UserJourneyController.confirmEvent:
              var response = await _services.createLiturgy(CreateLiturgyRequest(_session.organisationId, _state.name, _state.content));
              if (response.valid) {
                _navigator.goUp(context);
              } else {
                throw UserJourneyException('Failure to create liturgy');
              }
              _currentRoute = previewLiturgyRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            case UserJourneyController.backEvent:
              _currentRoute = recordLiturgyContentRoute;
              _navigator.goTo(context, _currentRoute, this, _state);
              c.complete();
              break;

            case UserJourneyController.cancelEvent:
              _navigator.goUp(context);
              c.complete();
              break;

            default:
              throw UserJourneyException('Invalid event for AddLiturgy Journey $_currentRoute - $event');
          }
          break;

        default:
          throw UserJourneyException('Invalid current route for AddLiturgy Journey $_currentRoute');
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


class AddLiturgyState implements StepInput, RecordLiturgyNameStateInput, RecordLiturgyContentStateInput {

  @override
  String name = '';
  @override
  String messageReference = '';
  @override
  String content = '';

}