///
/// Contains App Level constants.
///
/// This is used to ensure that constants have the same value across multitple libraries
///
library constants;

import 'package:flutter/material.dart';

/// Labels

const String emailLabel = 'email';
const String nameLabel = 'name';
const String passwordLabel = 'password';


/// Button Text

const String nextButton = 'Next';
const String previousButton = 'Previous';
const String cancelButton = 'Cancel';
const String confirmButton = 'Confirm';


/// error references

const String duplicateUser = 'duplicateUser';

/// miscellaneous

const String idFieldName = 'id';
const String userIdFieldName = 'userId';

/// screen size
const double screenHeight = 900;
const double screenWidth = 1600;
const double fontSize = 50;
const double margin = fontSize / 2;


///
/// A default mapping of Icons against the type of ServiceItem
///
const  Map<String, IconData> serviceTypeIcons = {
  'Liturgy': Icons.clean_hands,
  'Song' : Icons.music_note_sharp,
  'YouTube' : Icons.videocam,
  'Presentation' : Icons.slideshow
};

const TextStyle coreStyle = TextStyle( fontSize: fontSize, color: Colors.white, fontFamily: 'Raleway');