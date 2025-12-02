Feature: User can request a Password and Username Recovery
  As a GiftWise user who has forgotten their password or username,
  I want to reset my password,
  So that I can regain access to my account.

  Background:
    Given the following user exists in the database:
      | email           | username | password  |
      | test1@test.com  | test1    | 12345678  |

  Scenario: No identifier entered
    Given I am on the Account Recovery page
    When I enter "" into the identifier box
    And I press the Send Recovery Instructions button
    Then I should stay on the Account Recovery page
    And I should see "Please enter your email or username."

  Scenario: Request password reset with valid email
    Given I am on the Account Recovery page
    When I enter "test1@test.com" into the identifier box
    And I press the Send Recovery Instructions button
    Then I should be redirected to the login page
    And I should see "If this account exists, recovery instructions have been sent."

  Scenario: Request password reset with valid username
    Given I am on the Account Recovery page
    When I enter "test1" into the identifier box
    And I press the Send Recovery Instructions button
    Then I should be redirected to the login page
    And I should see "If this account exists, recovery instructions have been sent."

  Scenario: Request password reset with non-existent identifier
    Given I am on the Account Recovery page
    When I enter "notarealuser@test.com" into the identifier box
    And I press the Send Recovery Instructions button
    Then I should be redirected to the login page
    And I should see "If this account exists, recovery instructions have been sent."
