

import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/validators.dart';

import 'constants.dart';



class ConfigurationGetter implements ErrorMessageGetter {

  Map<String, String> screenText = <String, String>{

    /// page titles
    PersonalDetailsPage.titleRef: 'Personal Details',

    /// labels
    emailLabel: 'Email Address',
    nameLabel: 'Name',
    passwordLabel: 'Password',
    CapturePasswordPage.confirmPasswordLabel: 'Confirm Password',

    /// button text
    nextButton: 'Next',
    previousButton: 'Previous',


    /// error messages
    duplicateUser : 'This email address is already in use. Please try again.',

    Validator.nameError: 'Please provide a valid name.',
    Validator.emailError: 'Please provide a valid email address.',
    Validator.passwordError: 'Please provide a valid password',
    CapturePasswordPage.passwordMismatch: 'The two passwords must be the same.'


  };

  String getPageTitle(String id) {
    return screenText[id] ?? '';
  }

  String getLabel(String id) {
    return screenText[id] ?? '';
  }

  String getButtonText(String id) {
    return screenText[id] ?? '';
  }

  @override
  String getErrorMessage(String id) {
    return screenText[id] ?? '';
  }

}