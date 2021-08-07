

import 'package:jericho/journeys/liturgy/preivew_liturgy_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_content_page.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/login/login_controller.dart';
import 'package:jericho/journeys/login/login_page.dart';
import 'package:jericho/journeys/organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/organisation/new_organisation_page.dart';
import 'package:jericho/journeys/landing/landing_page.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/liturgy_services.dart';
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
    LoginPage.titleRef: 'Login',
    InviteToOrganisationPage.titleRef: 'Invite Users',
    RecordLiturgyNamePage.titleRef: 'Liturgy Name',
    PreviewLiturgyPage.titleRef : 'Preview and Confirm',
    RecordLiturgyContentPage.titleRef : 'Liturgy Content',



    /// labels
    emailLabel: 'Email Address',
    nameLabel: 'Name',
    passwordLabel: 'Password',
    CapturePasswordPage.confirmPasswordLabel: 'Confirm Password',
    NewOrganisationPage.organisationNameLabel: 'Your Organisation Name',
    RecordLiturgyNamePage.liturgyNameLabel: 'Liturgy Name',


    /// button text
    nextButton: 'Next',
    previousButton: 'Previous',
    cancelButton: 'Cancel',
    confirmButton: 'Confirm',
    LandingPage.inviteButtonTextRef: 'Invite User',


    /// error messages
    duplicateUser : 'This email address is already in use. Please try again.',

    Validator.nameError: 'Please provide a valid name.',
    Validator.emailError: 'Please provide a valid email address.',
    Validator.passwordError: 'Please provide a valid password',
    CapturePasswordPage.passwordMismatch: 'The two passwords must be the same.',
    OrganisationValidator.nameError: 'Please provide a name for your organisation',
    LiturgyValidator.nameError: 'Please provide a name for this piece of liturgy',
    LoginController.loginFailure : 'The email and password do not match those we have on record. Please try again.',

    /// generic screen text
    ConfirmOrganisationPage.confirmOrganisationTextRef: 'You have been invited to to join {string}. Please tap Next to confirm and continue',
    RecordLiturgyContentPage.initialMessage: 'Enter the content for the Liturgy here. The App splits the content up so that it fits on the screen.\n\n You can see a preview on the next page.'

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