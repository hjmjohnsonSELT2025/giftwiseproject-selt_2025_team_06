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

  Scenario: Reroute to Events Page
    When I am logged in as Username65 with password MyPass65
    And I click the "GiftWise" link in the navbar
    Then I should be taken to the events page

  Scenario: Reroute to Profile Page
    When I am logged in as Username65 with password MyPass65
    And I click the "Profile" link in the navbar
    Then I should be taken to the profile page for Username65

  Scenario: Reroute to Invite Page
    When I am logged in as Username65 with password MyPass65
    And I click the "Invites" link in the navbar
    Then I should be taken to the invites page for Username65

  Scenario: Successful Logout
    When I am logged in as Username65 with password MyPass65
    And I click the "Logout" link in the navbar
    Then I should be redirected to the login page
    And I should see "You have logged out successfully."

  Scenario: Navbar Hidden When Not Logged In
    When I am logged in as Username65 with password MyPass65
    And I click the "Logout" link in the navbar
    Then I should be redirected to the login page
    Then I should not see the navbar
