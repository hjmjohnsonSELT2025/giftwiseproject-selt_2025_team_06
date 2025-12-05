Feature: Event host removes attendees from an event
  As an event host
  I want to remove users from an event I created
  So that I can properly manage my event attendees

  Background: Users and events have already been added to the database
    Given the following users exist in the database:
      | email             | username | password | first_name | last_name |
      | tester1@test.com  | tester1  | 12345678  | Santa      | Claus     |
      | tester2@test.com  | tester2  | 12345678  | Mean       | Dude      |

    And the following event exists in the database:
      | title      | event_date   | location    | budget | theme             | event_creator |
      | TestEvent  | 2025-12-25   | North Pole  | 500    | Christmas Party   | tester1         |
    And that I am logged in with username "tester1"
    And user "tester1" has invited "tester2" who accepted to the event "TestEvent"

  Scenario: Event host removes an attendee from an event
    And I am on the view event page for "TestEvent"
    When I press "Remove Attendee" next to "tester2"
    Then "tester2" should no longer be attending the event "TestEvent"

  Scenario: A non-host cannot remove attendees
    Given that I am logged in with username "tester2"
    And I am on the view event page for "TestEvent"
    When I press "Remove Attendee" next to "tester2"
    Then I should see "Only the Host can remove attendee's"


