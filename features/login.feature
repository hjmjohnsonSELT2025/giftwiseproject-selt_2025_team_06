Feature: Logging in to account for website

  As a busy mother,
  I want to be able to log in to my account to view all of the events assigned to me,
  So that I can get access to all of my events that I will be attending.

  Background: Users have already been added to the database

  Given the following users exist:
  | email           | username   | password  |
  | user65@mojo.com | Username65 | MyPass65  |
  | user32@mojo.com | Username32 | MyPass32  |
  | user40@mojo.com | Username40 | MyPass40  |

  And I am on the login page
  Then 3 seed users should exist

Scenario: successful login
  When I enter Username65 in the username box
  And I enter MyPass65 in the password box
  And I press the “Log In” button
  Then I should be taken to the home page
  And I should be logged in as Username65

Scenario: unsuccessful login due to password
  When I enter Username65 in the username box
  And I enter MyPass32 in the password box
  And I press the “Log In” button
  Then I should remain on the login page
  And I should see "Incorrect password"

Scenario: unsuccessful login due to username
  When I enter unknown32 in the username box
  And I enter MyPass32 in the password box
  And I press the “Log In” button
  Then I should remain on the login page
  And I should see "Username doesn't exist"