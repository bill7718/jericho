Feature: Register User
  To test that I can register a new user

  Scenario: Happy path registration of a new user
    Given I expect the current page to be the "Personal Details" page
    When I enter "bill@bill.com" in "Email Address"
    And I enter "Bill" in "Name"
    Then I tap the "Next" button
    When I enter "hello1234" in "Password"
    And I enter "hello1234" in "Confirm Password"
    And I tap the "Next" button

