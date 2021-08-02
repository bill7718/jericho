import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';

import 'journeys/validators.dart';


var navigator = UserJourneyNavigator();
var getter = ConfigurationGetter();
var session = SessionState();
var validator = Validator(getter);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<UserJourneyNavigator>.value(value: navigator),
      Provider<ConfigurationGetter>.value(value: getter),
      Provider<Validator>.value(value: validator)
    ], child: const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
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
