Feature: Users can see events from Homepage
  As a gift-giver,
  I want to see events that I am a part of,
  So that I can view details of that event.

  Background: Users and events have already been added to the database

    Given the following users exists in the database:
      | email           | username   | password  |
      | test@example.com | Moaiz | 12345678  |
      | test2@example.com | Mike | 12345678  |

    And the following event exists in the database:
      | title           | event_date   | location  | budget  | theme  | event_creator  |
      | John's Birthday           | 2025-11-28   | Iowa City  | 1000  | Birthday  | Moaiz  |

  Scenario: User can see an event on homepage
    Given that I am logged in with username "Moaiz"
    And that I am on the home page
    Then I should see the event "John's Birthday" on the dashboard