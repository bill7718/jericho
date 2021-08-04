

import 'package:jericho/journeys/capture_organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/capture_organisation/new_organisation_page.dart';
import 'package:jericho/journeys/landing/landing_page.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/organisation_services.dart';

import 'constants.dart';



class ConfigurationGetter implements ErrorMessageGetter {

  Map<String, String> screenText = <String, String>{

    /// page titles
    PersonalDetailsPage.titleRef: 'Personal Details',
    CapturePasswordPage.titleRef: 'Create Password',
    NewOrganisationPage.titleRef: 'Create a New Organisation',
    ConfirmOrganisationPage.titleRef: 'Confirm Your Invitation',
    LandingPage.titleRef: 'Main Menu',

    /// labels
    emailLabel: 'Email Address',
    nameLabel: 'Name',
    passwordLabel: 'Password',
    CapturePasswordPage.confirmPasswordLabel: 'Confirm Password',
    NewOrganisationPage.organisationNameLabel: 'Your Organisation Name',

    /// button text
    nextButton: 'Next',
    previousButton: 'Previous',


    /// error messages
    duplicateUser : 'This email address is already in use. Please try again.',

    Validator.nameError: 'Please provide a valid name.',
    Validator.emailError: 'Please provide a valid email address.',
    Validator.passwordError: 'Please provide a valid password',
    CapturePasswordPage.passwordMismatch: 'The two passwords must be the same.',
    OrganisationValidator.nameError: 'Please provide a name for your organisation',

    /// generic screen text
    ConfirmOrganisationPage.confirmOrganisationTextRef: 'You have been invited to to join {string}. Please tap Next to confirm and continue',

  };

  String getPageTitle(String id) {
    return screenText[id] ?? '';
  }

  String getScreenText(String id, { List<String> parameters = const []}) {
    var response =  screenText[id] ?? '';

    for (var item in parameters) {
      response = response.replaceFirst('{string}', item);
    }

    return response;
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