Feature: Footer support and planning information

  As a busy user,
  I want a footer that provides quick access to support and planning information,
  So that I can easily find help and stay organized.

  Background: Users have already been added to the database

    Given the following users exist:
      | email           | username   | password  |
      | user65@mojo.com | Username65 | MyPass65  |
      | user32@mojo.com | Username32 | MyPass32  |
      | user40@mojo.com | Username40 | MyPass40  |

    And I am on the login page
    Then 3 seed users should exist

    When I enter Username65 in the username box
    And I enter MyPass65 in the password box
    And I press the “Log In” button
    Then I should be taken to the home page

  Scenario: Showing no events message
    When I am logged in as Username65 with password MyPass65
    And I have no upcoming events
    Then I should see a message indicating that no events are scheduled

  Scenario: Seeing gift planning tips
    When I am logged in as Username65 with password MyPass65
    Then I should see a gift planning tip displayed in the footer

  Scenario: Footer hidden while logged out
    When I click the "Logout" link in the navbar
    Then I should be redirected to the login page
    Then I should not see the footer

  Scenario: Footer showing support link
    When I am logged in as Username65 with password MyPass65
    Then I should see a link to the support or help page in the footer

  Scenario: Footer showing contact information
    When I am logged in as Username65 with password MyPass65
    When I am on the events page
    Then I should see support contact information in the footer