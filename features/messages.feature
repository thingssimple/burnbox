Feature: Messages

  Scenario: Create a message
    Given I am on the homepage
    When I create a message
    Then I should see the message URL

  Scenario: View a message
    Given a message
    When I go to that message's page
    Then I should see the message
    And the message should deleted

  Scenario: Upload a file
    Given I am on the homepage
    When I create a message with a file
    Then the message should have a file

  Scenario: Download a file
    Given a message with a file
    When I go to that message's page
    Then I should see the file
    And the file should deleted
