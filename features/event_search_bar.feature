Feature: Event search and filtering

  As a popular person,
  I want to view only events specified by my search parameters
  So that I can easily find events based on budget, name, or date

Background:
Given the following events exist:
| event_name     | event_date  | event_owner    | event_budget |
| Birthday Party | 2025-11-20  | Sarah Miller   | 50           |
| Family Dinner  | 2025-12-25  | James Carter   | 250          |
| Secret Santa   | 2025-12-15  | Olivia Newton  | 150          |
And I am registered for all events


Scenario: Viewing all events on the home page
  When I am on the home page
  Then I should see the following events:
  | Birthday Party |
  | Family Dinner  |
  | Secret Santa   |


Scenario: Filtering events by budget range
  When I am on the home page
  And I enter a minimum budget of 20
  And I enter a maximum budget of 100
  And I apply the filters
  Then I should see the following events:
  | Birthday Party |
  And I should not see the following events:
  | Family Dinner |
  | Secret Santa  |



Scenario: Sorting events by name in descending order
  When I am on the home page
  And I select "Name" as the sort criterion
  And I select "Descending" order
  And I apply the filters
  Then I should see the events in the following order:
  | Secret Santa   |
  | Family Dinner  |
  | Birthday Party |


Scenario: Sorting events by name in ascending order
  When I am on the home page
  And I select "Name" as the sort criterion
  And I select "Ascending" order
  And I apply the filters
  Then I should see the events in the following order:
  | Birthday Party |
  | Family Dinner  |
  | Secret Santa   |


Scenario: Sorting events by date in descending order
  When I am on the home page
  And I select "Date" as the sort criterion
  And I select "Descending" order
  And I apply the filters
  Then I should see the events in the following order:
  | Family Dinner  |
  | Secret Santa   |
  | Birthday Party |


Scenario: Sorting events by date in ascending order
  When I am on the home page
  And I select "Date" as the sort criterion
  And I select "Ascending" order
  And I apply the filters
  Then I should see the events in the following order:
  | Birthday Party |
  | Secret Santa   |
  | Family Dinner  |

Scenario: Searching events by title
  When I am on the home page
  And I enter "Birthday" into the search title field
  And I apply the filters
  Then I should see the following events:
  | Birthday Party |
  And I should not see the following events:
  | Family Dinner |
  | Secret Santa  |