Feature: Managing friends on the platform
  As a logged-in user
  I want to add, view, and accept friends
  So that I can connect with people and invite them to events

  Background:
    Given the following basic users exist:
      | email             | username | password |
      | user1@test.com    | user1    | password123 |
      | user2@test.com    | user2    | password123 |
      | user3@test.com    | user3    | password123 |


  Scenario: Viewing my friends list
    Given I am logged in as "user1"
    Given "user1" and "user2" are friends
    And I am on the friendships page
    Then I should see "user2" in my friends list

  Scenario: Sending a friend request
    Given I am logged in as "user1"
    And I am on the friendships page
    When I add "user3" as a friend
    Then "user3" should receive a friend request
    And I should see "Friend request sent"

  Scenario: Accepting a friend request
    Given "user1" has sent a friend request to "user2"
    And I am logged in as "user2"
    And I am on the friendships page
    When I accept the friend request from "user1"
    Then "user1" should appear in my friends list

  Scenario: Prevent adding yourself as a friend
    Given I am logged in as "user1"
    And I am on the friendships page
    When I try to add myself as a friend
    Then I should see "Can't add yourself as a friend"
