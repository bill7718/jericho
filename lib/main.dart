import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';

var navigator = UserJourneyNavigator();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<UserJourneyNavigator>.value(value: navigator),
    ], child: const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final j = Provider.of<UserJourneyNavigator>(context);
    scheduleMicrotask(() {
      j.gotDownToNextJourney(context, UserJourneyController.registerUserJourney);
    });

    return Container();
  }
}
