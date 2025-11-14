Feature: User can create an event
  As an event planner,
  I want to create an event,
  So that I can make it easy to give gifts to other people.

  Background: Users have already been added to the database

  Given the following users exist:
  | email           | username   | password  |
  | test@example.com | moaiztest | 12345678  |

Scenario: Try to create an event with missing details
  Given that I am logged in with username "Moaiz"
  And that I am on the event creation page
  When I attempt to create an event with missing details
  Then I should see an error "Please fill out all the fields"

Scenario: Create an event with correct details
