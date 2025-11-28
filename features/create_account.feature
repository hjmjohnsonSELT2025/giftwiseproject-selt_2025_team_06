Feature: Creating an Account for website

  As a busy mother,
  I want to have an account on this site for my tracking,
  So that I can properly plan the right gifts for all of those I know.

  Background:
    Given the following users exist:
      | email           | username   | password  | first_name | last_name |
      | user65@mojo.com | Username65 | MyPass65  | Paul       | Jones     |
      | user32@mojo.com | Username32 | MyPass32  | Aaron      | Senior    |
      | user40@mojo.com | Username40 | MyPass40  | Billy      | Bill      |
    And I visit the create account page
    Then 3 seed users should exist

  Scenario: Invalid Password in Account Creation
    When I enter "newuser@mojo.com" in the create account email box
    And I enter "NewUsername" in the create account username box
    And I enter "pass" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "Teacher" in the create account occupation box
    And I press the Create Account button
    Then I should see "Password Invalid"

  Scenario: No Password in Account Creation
    When I enter "newuser2@mojo.com" in the create account email box
    And I enter "NewUsername2" in the create account username box
    And I enter "" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "Teacher" in the create account occupation box
    And I press the Create Account button
    Then I should see "Password Invalid"

  Scenario: Date of Birth Missing in Account Creation
    When I enter "newuser3@mojo.com" in the create account email box
    And I enter "NewUsername3" in the create account username box
    And I enter "Password56" in the create account password box
    And I enter "" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "Teacher" in the create account occupation box
    And I press the Create Account button
    Then I should see "DOB Empty"

  Scenario: Hobbies Missing in Account Creation
    When I enter "newuser4@mojo.com" in the create account email box
    And I enter "NewUsername4" in the create account username box
    And I enter "Password56" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "" in the create account hobbies box
    And I press the Create Account button
    Then I should see "Hobbies Empty"

  Scenario: Occupation Missing in Account Creation
    When I enter "newuser5@mojo.com" in the create account email box
    And I enter "NewUsername5" in the create account username box
    And I enter "Password56" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "" in the create account occupation box
    And I press the Create Account button
    Then I should be taken to the home page
    And I should see a message "Account created successfully!"

  Scenario: Username Taken in Account Creation
    When I enter "newuser6@mojo.com" in the create account email box
    And I enter "Username65" in the create account username box
    And I enter "Password65" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "Teacher" in the create account occupation box
    And I press the Create Account button
    Then I should see "Username Taken"

  Scenario: Email Taken in Account Creation
    When I enter "user65@mojo.com" in the create account email box
    And I enter "NewUsername7" in the create account username box
    And I enter "Password65" in the create account password box
    And I enter "10/10/2000" in the create account birthdate box
    And I enter "hiking" in the create account hobbies box
    And I enter "Teacher" in the create account occupation box
    And I press the Create Account button
    Then I should see "Email Taken"