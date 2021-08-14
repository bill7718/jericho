library templates;

import 'package:waterloo/waterloo_form_message.dart';
///
/// {@template template_name}
///  Some shared docs
/// {@endtemplate}
///
/// {@template inputState}
/// Specifies the input data for this page
/// {@endtemplate}
///
/// {@template outputState}
/// Specifies the data that this page provides to the [EventHandler]
/// {@endtemplate}
///
/// {@template dynamicState}
/// Specifies the data that this page uses to maintain any mutable state
/// {@endtemplate}
///
/// {@template titleRef}
/// Screen reference for the title that appears in the [AppBar]
/// {@endtemplate}
///
/// {@template initialMessage}
/// Screen reference message shown on entry to the page. This message appears in the [WaterlooFormMessage] at the stop of the page unless an
/// error message is passed into the [FormError] object linked to the [WaterlooFormMessage] widget in this page.
/// {@endtemplate}
var dummyValue = 1; // this code is needed otherwise the templates are not used by the docs