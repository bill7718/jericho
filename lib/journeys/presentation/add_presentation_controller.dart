
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
class AddPresentationController extends MappedJourneyController {

  /// The route for the [RecordPresentationNamePage]
  static const String recordPresentationRoute = '/recordPresentation';

  /// The error reference used if the user tries to create a duplicate presentation
  /// see also [ConfigurationGetter]
  static const String duplicatePresentation = 'duplicatePresentation';

  @override
  String currentRoute = '';

  /// {@macro journeyState}
  final AddPresentationState _state = AddPresentationState();

  /// Server communication for user data
  final PresentationServices _services;

  /// {@macro sessionState}
  final SessionState _session;

  AddPresentationController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);

  @override
  StepInput get state => _state;

  @override
  Map<String, Map<String, dynamic>> get functionMap => {
    MappedJourneyController.initialRoute: {
      UserJourneyController.initialEvent: MappedJourneyController.goDown + recordPresentationRoute
    },
    recordPresentationRoute: {
      UserJourneyController.backEvent: MappedJourneyController.goUp,
      UserJourneyController.nextEvent: handleNextOnRecordPresentation,
    }
  };

  ///
  /// Create a presentation object and upload the data on to the file server
  ///
  Future<void> handleNextOnRecordPresentation(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordPresentationStateOutput;
    var checkResponse =
    await _services.checkPresentation(CheckPresentationRequest(_session.organisationId, o.name));
    if (checkResponse.valid) {
      await _services.createPresentation(CreatePresentationRequest(_session.organisationId, o.name, o.data));
      navigator.goUp(context);
    } else {
      _state.messageReference = duplicatePresentation;
      _state.name = o.name;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }


}

/// {@macro journeyState}
class AddPresentationState implements StepInput, RecordPresentationStateInput {
  @override
  String name = '';
  @override
  String messageReference = '';
  Uint8List data = Uint8List(0);
}
