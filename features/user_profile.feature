Feature: User profile page
  As a logged-in user
  I want to interact with my profile page buttons
  So that I can edit, change my password, delete my account, or go back to events

  Background:
    Given the following users exist:
      | email            | username | password   |
      | test@example.com | tester   | password123 |
    And I am logged in as "tester"


  Scenario: Edit Account modal opens
    When I visit my profile page
    And I click "Edit Account"
    Then I should see "Edit Account" in a popup


  Scenario: Change Password page opens
    When I visit my profile page
    And I click "Change Password"
    Then I should be taken to the change password page

  Scenario: Delete Account popup works
    When I visit my profile page
    And I click the Delete Account trigger
    Then I should see "Confirm Account Deletion"
    When I confirm deletion with "tester"
    Then my account should be deleted
