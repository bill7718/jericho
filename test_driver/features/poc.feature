Feature: POC
  To test that I can run the system via Gherkin

  Scenario: Show the first page and see if the fields are present
    Given I expect the "Email Address" to be present
    And I expect the "Name" to be present
