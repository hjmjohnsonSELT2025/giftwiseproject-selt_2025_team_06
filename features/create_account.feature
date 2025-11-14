Feature: Creating an Account for website

  As a busy mother,
  I want to have an account on this site for my tracking,
  So that I can properly plan the right gifts for all of those I know.

  Background: Users have already been added to database

    Given the following users exist:
      | email           | username   | password  |
      | user65@mojo.com | Username65 | MyPass65  |
      | user32@mojo.com | Username32 | MyPass32  |
      | user40@mojo.com | Username40 | MyPass40  |

    And I am on the create account page
    Then 3 seed users should exist

  Scenario: Invalid Password in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username65" in the username box
    And I enter "pass" in the password box
    And I enter "10/10/2000" in the birthdate box
    And I enter "hiking" in the hobbies box
    And I enter "Teacher" in the occupation box
    And I press the "Create Account" button
    Then I should see "Password Invalid"

  Scenario: No Password in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username56" in the username box
    And I enter "" in the password box
    And I enter "10/10/2000" in the birthdate box
    And I enter "hiking" in the hobbies box
    And I enter "Teacher" in the occupation box
    And I press the "Create Account" button
    Then I should see "Password Invalid"

  Scenario: Date of Birth Missing in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username56" in the username box
    And I enter "Password56" in the password box
    And I enter "" in the birthdate box
    And I enter "hiking" in the hobbies box
    And I enter "Teacher" in the occupation box
    And I press the "Create Account" button
    Then I should see "DOB Empty"

  Scenario: Hobbies Missing in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username65" in the username box
    And I enter "Password56" in the password box
    And I enter "10/10/2000" in the birthdate box
    And I enter "" in the hobbies box
    And I press the "Create Account" button
    Then I should see "Hobbies Empty"

  Scenario: Occupation Missing in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username65" in the username box
    And I enter "Password56" in the password box
    And I enter "10/10/2000" in the birthdate box
    And I enter "hiking" in the hobbies box
    And I enter "" in the occupation box
    And I press the "Create Account" button
    Then I should be taken to the home page
    And I should be logged in as "Username65"

  Scenario: Username Taken in Account Creation
    When I enter "user65@mojo.com" in the email box
    And I enter "Username65" in the username box
    And I enter "Password56" in the password box
    And I enter "10/10/2000" in the birthdate box
    And I enter "hiking" in the hobbies box
    And I enter "Teacher" in the occupation box
    And I press the "Create Account" button
    Then I should see "Username Taken"