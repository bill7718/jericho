import 'dart:async';
import 'package:jericho/journeys/event_handler.dart';

import 'preview_service_page.dart';
import 'record_service_name_page.dart';
import 'record_service_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import 'package:jericho/services/service_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
class AddServiceController extends MappedJourneyController {
  static const String recordServiceRoute = '/recordService';
  static const String recordServiceNameRoute = '/recordServiceName';
  static const String previewServiceRoute = '/previewService';

  static const String duplicateServiceErrorReference = 'duplicateService';

  final AddServiceState _state = AddServiceState();
  final ServiceServices _services;
  final SessionState _session;

  AddServiceController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  String currentRoute = MappedJourneyController.initialRoute;

  @override
  StepInput get state => _state;

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
        MappedJourneyController.initialRoute: {
          UserJourneyController.initialEvent: MappedJourneyController.goDown + recordServiceNameRoute
        },
        recordServiceNameRoute: {
          UserJourneyController.nextEvent: handleNextOnRecordName,
          UserJourneyController.backEvent: MappedJourneyController.goUp
        },
        recordServiceRoute: {
          UserJourneyController.nextEvent: handleNextOnRecordService,
          UserJourneyController.backEvent: recordServiceNameRoute
        },
        previewServiceRoute: {
          UserJourneyController.nextEvent: handleNextOnPreviewService,
          UserJourneyController.backEvent: recordServiceRoute
        },
      };

  ///
  /// Check to see if the name is in use
  ///
  /// If it is not in use then
  /// - save the name to the journey state
  /// - retrieve all possible service items (e.g. songs, liturgy) from the database
  /// - add those items into the journey state and go to the page that adds those items into the service
  ///
  /// If the name is in use then return to the name page with error [duplicateServiceErrorReference]
  ///
  Future<void> handleNextOnRecordName(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordServiceNameStateOutput;
    var checkResponse = await _services.checkService(CheckServiceRequest(_session.organisationId, o.name));
    if (checkResponse.valid) {
      currentRoute = recordServiceRoute;
      _state.name = o.name;
      var allItems =
          await _services.getAllServiceItems(GetAllServiceItemsRequest(organisationId: _session.organisationId));
      _state.serviceItems.clear();
      _state.serviceItems.addAll(allItems.data);
      navigator.goTo(context, currentRoute, this, _state);
    } else {
      _state.messageReference = duplicateServiceErrorReference;
      _state.name = o.name;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }

  ///
  /// Store the current service items in the journey state nad go to the
  /// review page
  ///
  Future<void> handleNextOnRecordService(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordServiceStateOutput;
    currentRoute = previewServiceRoute;
    _state.fullServiceContent.clear();
    _state.fullServiceContent.addAll(o.serviceContents);
    navigator.goTo(context, currentRoute, this, _state);

    c.complete();
    return c.future;
  }

  ///
  /// Create the service in the database and leave the journey
  ///
  Future<void> handleNextOnPreviewService(context, StepOutput output) async {
    var c = Completer<void>();

    var response =
        await _services.createService(CreateServiceRequest(_session.organisationId, _state.name, _state.serviceItems));

    if (response.valid) {
      navigator.goUp(context);
      c.complete();
    } else {
      c.completeError(UserJourneyException('failed to create service ${_state.name} : ${_state.serviceItems}'));
    }

    return c.future;
  }
}

/// {@macro journeyState}
class AddServiceState
    implements StepInput, RecordServiceNameStateInput, PreviewServiceNameStateInput, RecordServiceStateInput {
  @override
  String name = '';
  @override
  String messageReference = '';

  @override
  List<Map<String, dynamic>> serviceItems = <Map<String, dynamic>>[];

  @override
  List<Map<String, dynamic>> fullServiceContent = <Map<String, dynamic>>[];
}
