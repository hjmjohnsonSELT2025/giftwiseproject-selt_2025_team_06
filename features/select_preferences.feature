Feature: User selects likes and dislikes
  As a registered user
  I want to choose what I like and dislike
  So the system can recommend better gift ideas

  Background:
    Given a user exists with username "testuser" email "test@example.com" and password "password"
    And I am logged in as "testuser"
    And the following preferences exist:
      | name   |
      | coffee |
      | tea    |
      | lego   |

  Scenario: Selecting an existing preference as a like
    When I visit the preferences page
    And I check "coffee" under likes
    And I press "Continue"
    Then I should see "Preferences saved!"
    And the user should have preference "coffee" with category "like"

  Scenario: Selecting an existing preference as a dislike
    When I visit the preferences page
    And I check "tea" under dislikes
    And I press "Continue"
    Then I should see "Preferences saved!"
    And the user should have preference "tea" with category "dislike"

  Scenario: Adding a new custom preference as a like
    When I visit the preferences page
    And I fill in "add-pref-name" with "matcha"
    And I press "Add Preference"
    And I check "matcha" under likes
    And I press "Continue"
    Then I should see "Preferences saved!"
    And the user should have preference "matcha" with category "like"