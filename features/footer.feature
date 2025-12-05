Feature: Footer support and planning information

  As a busy user,
  I want a footer that provides quick access to support and planning information,
  So that I can easily find help and stay organized.

  Background: Users have already been added to the database

    Given the following users exist:
      | email           | username   | password  | first_name | last_name |
      | user65@mojo.com | Username65 | MyPass65  | Paul       | Jones     |
      | user32@mojo.com | Username32 | MyPass32  | Aaron      | Senior    |
      | user40@mojo.com | Username40 | MyPass40  | Billy      | Bill      |

    And I am on the login page
    Then 3 seed users should exist

    When I enter Username65 in the username box
    And I enter MyPass65 in the password box
    And I press the “Log In” button
    Then I should be taken to the home page

  Scenario: Showing next upcoming event
    When I am logged in as Username65 with password MyPass65
    Then I should see the closest upcoming event displayed in the footer

  Scenario: Showing days until next event
    When I am logged in as Username65 with password MyPass65
    Then I should see how many days remain until my nearest event in the footer

  Scenario: Showing no events message
    When I am logged in as Username65 with password MyPass65
    And I have no upcoming events
    Then I should see a message indicating that no events are scheduled

  Scenario: Seeing gift planning tips
    When I am logged in as Username65 with password MyPass65
    Then I should see a gift planning tip displayed in the footer

  Scenario: Tips hidden while logged out
    When I am logged out
    Then I should not see any gift planning tips in the footer

  Scenario: Footer showing support link
    When I am logged in as Username65 with password MyPass65
    Then I should see a link to the support or help page in the footer

  Scenario: Footer showing contact information
    When I am logged in as Username65 with password MyPass65
    And I am on any page
    Then I should see support contact information in the footer

  Scenario: Clear help label
    When I am logged in as Username65 with password MyPass65
    And I am on any page
    Then the help or support section in the footer should be clearly labeled
