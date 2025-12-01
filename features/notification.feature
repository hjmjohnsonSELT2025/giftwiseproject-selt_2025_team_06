Feature: User gets notification when invited to an event
  As an gift-giver,
  I want to see a notification for an event invite on my dashboard,
  So that I can join an event that I have been invited to.

  Background: Users and events have already been added to the database

    Given the following users exists in the database:
      | email           | username   | password  |
      | test@example.com | Moaiz | 12345678  |
      | test2@example.com | Mike | 12345678  |

    And the following event exists in the database:
      | title           | event_date   | location  | budget  | theme  | event_creator  |
      | John's Birthday           | 2025-11-28   | Iowa City  | 1000  | Birthday  | Moaiz  |

    And user "Moaiz" has invited "Mike" to the event "John's Birthday"


  Scenario: User can see notification for event invite
    Given that I am logged in with username "Mike"
    And that I am on the home page
    When I press the "Invites" button
    Then I should see an invite listed for "John's Birthday"

  Scenario: User is added to event by accepting invite
    Given that I am logged in with username "Mike"
    And that I am on the notifications page
    And that I can see an invite listed for "John's Birthday"
    When I press the "Accept" button
    Then I should see the event "John's Birthday" on the dashboard



