Feature: Navbar navigation for logged-in users

  As a busy user,
  I want a navbar to access the important pages,
  So that I can navigate quickly and efficiently to where I need to go.

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

  Scenario: Reroute to Events Page
    When I click the "Events" link in the navbar
    Then I should be taken to the events page

  Scenario: Reroute to Profile Page
    When I click the "Profile" link in the navbar
    Then I should be taken to the profile page for Username65

  Scenario: Successful Logout
    When I click the "Logout" link in the navbar
    Then I should be redirected to the login page
    And I should see "Logged out successfully"

  Scenario: Navbar Hidden When Not Logged In
    When I log out manually
    Then I should not see the navbar
