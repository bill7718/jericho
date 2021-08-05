import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/key_generator.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:jericho/services/mock_firebase_service.dart';
import 'package:jericho/services/mock_authentication_service.dart';
import 'package:jericho/services/organisation_services.dart';
import 'package:jericho/services/user_services.dart';
import 'package:provider/provider.dart';

import 'journeys/poc_page.dart';
import 'journeys/validators.dart';


var navigator = UserJourneyNavigator();
var getter = ConfigurationGetter();
var session = SessionState();
var validator = Validator(getter);
var firebase = MockFirebaseService();
var organisationValidator = OrganisationValidator(getter);


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
      Provider<OrganisationValidator>.value(value: organisationValidator)
    ], child: const MaterialApp(debugShowCheckedModeBanner: false,
    //    home: HomePage()
      home: POCPage()
    ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final j = Provider.of<UserJourneyNavigator>(context);
    scheduleMicrotask(() {
      j.gotDownToNextJourney(context, UserJourneyController.registerUserJourney, session);
    });

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