import 'dart:async';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'record_liturgy_content_page.dart';
import 'record_liturgy_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';


///
/// Controls the flow of control when a user wants to Add a new Liturgy item
///
/// {@category LiturgyJourneys}
///
class AddLiturgyController extends MappedJourneyController {

  /// The route for the [RecordLiturgyNamePage]
  static const String recordLiturgyNameRoute = '/recordLiturgyName';

  /// The route for the [RecordLiturgyContentPage]
  static const String recordLiturgyContentRoute = '/recordLiturgyContent';

  /// The route for the [PreviewLiturgyPage]
  static const String previewLiturgyRoute = '/previewLiturgy';

  /// The error reference used if the users tries to create liturgy with a duplicate name
  /// see also [ConfigurationGetter]
  static const String duplicateLiturgy = 'duplicateLiturgy';

  @override
  String currentRoute = '';

  /// The state object for this journey
  final AddLiturgyState _state = AddLiturgyState();

  /// This object handles the server communication
  final LiturgyServices _services;

  /// The overall session data (e.g. user name and email)
  ///
  /// It contains the id of the organisation of the logged in user
  ///
  final SessionState _session;

  AddLiturgyController(UserJourneyNavigator navigator, this._services, this._session) : super(navigator);


  @override
  Map<String, Map<String, dynamic>> get functionMap => {
    MappedJourneyController.initialRoute: {
      UserJourneyController.initialEvent: MappedJourneyController.goDown + recordLiturgyNameRoute
    },
    recordLiturgyNameRoute: {
      UserJourneyController.nextEvent: handleNextOnRecordName,
      UserJourneyController.backEvent: MappedJourneyController.goUp
    },
    recordLiturgyContentRoute: {
      UserJourneyController.nextEvent: handleNextOnRecordContent,
      UserJourneyController.backEvent: recordLiturgyNameRoute,
      UserJourneyController.cancelEvent: MappedJourneyController.goUp
    },
    previewLiturgyRoute: {
      UserJourneyController.confirmEvent: handleConfirmOnPreview,
      UserJourneyController.backEvent: recordLiturgyContentRoute,
      UserJourneyController.cancelEvent: MappedJourneyController.goUp
    },
  };

  @override
  StepInput get state => _state;

  ///
  /// After the name is recorded the system
  /// - stores the name in the journey state
  /// - checks that the name is not already in use
  /// - goes on to the next page
  ///
  Future<void> handleNextOnRecordName(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordLiturgyNameStateOutput;
    _state.name = o.name;
    var response = await _services.getLiturgy(GetLiturgyRequest(organisationId: _session.organisationId, name: o.name));
    if (response.valid) {
      // a liturgy with this name is found
      _state.messageReference = duplicateLiturgy;
      navigator.goTo(context, currentRoute, this, _state);
    } else {
      currentRoute = recordLiturgyContentRoute;
      navigator.goTo(context, currentRoute, this, _state);
    }

    c.complete();
    return c.future;
  }

  ///
  /// After the content is recorded the system
  /// - stores the content in the journey state
  /// - goes on to the next page
  ///
  Future<void> handleNextOnRecordContent(context, StepOutput output) async {
    var c = Completer<void>();

    var o = output as RecordLiturgyContentStateOutput;
    _state.content = o.content;
    currentRoute = previewLiturgyRoute;
    navigator.goTo(context, currentRoute, this, _state);

    c.complete();
    return c.future;
  }

  ///
  /// After the user confirms that the previewed liturgy is ok the system
  /// - creates the liturgy on the database
  /// - leaves the journey
  ///
  Future<void> handleConfirmOnPreview(context, StepOutput output) async {
    var c = Completer<void>();

    var response = await _services.createLiturgy(CreateLiturgyRequest(_session.organisationId, _state.name, _state.content));
    if (response.valid) {
      navigator.goUp(context);
    } else {
      throw UserJourneyException('Failure to create liturgy');
    }
    currentRoute = previewLiturgyRoute;
    navigator.goTo(context, currentRoute, this, _state);

    c.complete();
    return c.future;
  }


}

///
/// The persistent state managed by the [AddLiturgyController] Journey
///
class AddLiturgyState implements StepInput, RecordLiturgyNameStateInput, RecordLiturgyContentStateInput, PreviewLiturgyStateInput {

  ///
  /// The name given to the liturgy
  ///
  @override
  String name = '';

  ///
  /// The reference of any error message to be displayed on the page
  ///
  @override
  String messageReference = '';

  ///
  /// The liturgy content
  ///
  @override
  String content = '';

}