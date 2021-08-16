import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:jericho/journeys/configuration/configuration_getter.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/key_generator.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:jericho/services/mock_firebase_service.dart';
import 'package:jericho/services/mock_authentication_service.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:jericho/services/presentation_services.dart';
import 'package:jericho/services/service_services.dart';
import 'package:jericho/services/user_services.dart';
import 'package:jericho/services/you_tube_services.dart';
import 'package:jericho/test_pages/generic_journey.dart';
import 'package:jericho/test_pages/test_record_liturgy.dart';
import 'package:jericho/test_pages/test_record_service.dart';
import 'package:jericho/test_pages/test_record_youtube.dart';
import 'package:provider/provider.dart';

import 'journeys/poc_page.dart';
import 'journeys/validators.dart';


var navigator = UserJourneyNavigator();
var getter = ConfigurationGetter();
var session = SessionState();
var validator = Validator(getter);
var firebase = MockFirebaseService();
var organisationValidator = OrganisationValidator(getter);
var liturgyValidator = LiturgyValidator(getter);
var presentationValidator = PresentationValidator(getter);
var youTubeValidator = YouTubeValidator(getter);
var serviceValidator = ServiceValidator(getter);



void main() {
  registerDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<UserJourneyNavigator>.value(value: navigator),
      Provider<ConfigurationGetter>.value(value: getter),
      Provider<Validator>.value(value: validator),
      Provider<OrganisationValidator>.value(value: organisationValidator),
      Provider<LiturgyValidator>.value(value: liturgyValidator),
      Provider<PresentationValidator>.value(value: presentationValidator),
      Provider<YouTubeValidator>.value(value: youTubeValidator),
      Provider<ServiceValidator>.value(value: serviceValidator),
    ], child: const MaterialApp(debugShowCheckedModeBanner: false,
        //home: HomePage(initialiser: testPreviewLiturgy,)
       home: POCPage()
    ));
  }
}

class HomePage extends StatelessWidget {

  final String journey;
  final Function initialiser;

  const HomePage({Key? key, this.journey = UserJourneyController.registerUserJourney, this.initialiser = dummy}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GenericJourneyInput g = initialiser();
    if (g.route.isEmpty) {
      final j = Provider.of<UserJourneyNavigator>(context);
      scheduleMicrotask(() {
        j.gotDownToNextJourney(context, journey, session);
      });
    } else {
      final n = Provider.of<UserJourneyNavigator>(context);
      final j = GenericJourney(n, g.route, g.input);

      scheduleMicrotask(() {
        j.handleEvent(context);
      });
    }

    return Container();
  }
}
void registerDependencies() {

  Injector.appInstance.registerSingleton<KeyGenerator>(() => KeyGenerator());
  Injector.appInstance.registerSingleton<AuthenticationService>(() => MockAuthenticationService());

  Injector.appInstance.registerSingleton<DataService>(() => DataService(
    firebase,
    Injector.appInstance.get<KeyGenerator>()
  ));

  Injector.appInstance.registerSingleton<UserServices>(() => UserServices(
         Injector.appInstance.get<DataService>(),
    Injector.appInstance.get<AuthenticationService>(),
      ));


  Injector.appInstance.registerSingleton<OrganisationServices>(() => OrganisationServices(
    Injector.appInstance.get<DataService>(),
  ));

  Injector.appInstance.registerSingleton<LiturgyServices>(() => LiturgyServices(
    Injector.appInstance.get<DataService>(),
  ));

}

GenericJourneyInput dummy()=>GenericJourneyInput('', EmptyStepInput());