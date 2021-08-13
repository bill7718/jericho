import 'dart:async';
import 'package:jericho/journeys/event_handler.dart';

import 'package:jericho/journeys/service/preview_service_page.dart';
import 'package:jericho/journeys/service/record_service_name_page.dart';
import 'package:jericho/journeys/service/record_service_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

import 'package:jericho/services/service_services.dart';

///
/// Controls the flow of control when a user wants to Add a presentation item
///
///
class AddServiceController extends MappedJourneyController {
  static const String recordServiceRoute = '/recordService';
  static const String recordServiceNameRoute = '/recordServiceName';
  static const String previewServiceRoute = '/previewService';

  static const String duplicateService = 'duplicateService';

  final AddServiceState _state = AddServiceState();
  final ServiceServices _services;
  final SessionState _session;

  AddServiceController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  String currentRoute = MappedJourneyController.initialRoute;

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

  Future<void> handleNextOnRecordName(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordServiceNameStateOutput;
    var checkResponse = await _services.checkService(CheckServiceRequest(_session.organisationId, o.name));
    if (checkResponse.valid) {
      currentRoute = recordServiceRoute;
      _state.name = o.name;
      var allItems = await _services.getAllServiceItems(GetAllServiceItemsRequest(organisationId: _session.organisationId));
      _state.serviceItems.clear();
      _state.serviceItems.addAll(allItems.data);
      navigator.goTo(context, currentRoute, this, _state);
    } else {
      _state.messageReference = duplicateService;
      _state.name = o.name;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }

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

  Future<void> handleNextOnPreviewService(context, StepOutput output) async {
    var c = Completer<void>();

    var response = await _services
        .createService(CreateServiceRequest(_session.organisationId, _state.name, _state.serviceItems));

    if (response.valid) {
      navigator.goUp(context);
      c.complete();
    } else {
      c.completeError(UserJourneyException('failed to create service ${_state.name} : ${_state.serviceItems}'));
    }

    return c.future;
  }
}

class AddServiceState
    implements StepInput, RecordServiceNameStateInput, PreviewServiceNameStateInput, RecordServiceStateInput {
  String name = '';
  String messageReference = '';

  List<Map<String, dynamic>> serviceItems = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> fullServiceContent = <Map<String, dynamic>>[];


}
