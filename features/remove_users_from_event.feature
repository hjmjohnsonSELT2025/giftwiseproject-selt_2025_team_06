Feature: Event host removes attendees from an event
  As an event host
  I want to remove users from an event I created
  So that I can properly manage my event attendees

  Background:
    Given the following users exist in the database:
      | email             | username | password | first_name | last_name |
      | tester1@test.com  | tester1  | tester1  | Santa      | Claus     |
      | tester2@test.com  | tester2  | tester2  | Mean       | Dude      |

    And the following event exists in the database:
      | title      | event_date   | location    | budget | theme             | event_creator |
      | TestEvent  | 2025-12-25   | North Pole  | 500    | Christmas Party   | Santa         |

    And user "tester1" has invited "tester2" to the event "TestEvent"

  Scenario: Event host removes an attendee from an event
    Given I am logged in as "tester1"
    And I am on the view event page for "TestEvent"
    When I press "Remove Attendee" next to "tester2"
    Then "tester2" should no longer be attending the event "TestEvent"

  Scenario: Removing a user who is NOT invited does nothing
    Given I am logged in as "tester1"
    And I am on the view event page for "TestEvent"
    When I press "Remove Attendee" next to "tester3"
    Then I should see "User not found or not attending"

  Scenario: A non-host cannot remove attendees
    Given I am logged in as "tester2"
    And I am on the view event page for "TestEvent"
    When I press "Remove Attendee" next to "tester2"
    Then I should see "You do not have permission to remove attendees"
