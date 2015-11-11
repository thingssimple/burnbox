Feature: API

  Scenario: Successfully creating a message from the API
    When I POST the following messages:
      | text | test |
    Then the response should include a "url"

  Scenario: Unsuccessfully creating a message
    When I POST the following messages:
      | | |
    Then the response should include a "errors"
