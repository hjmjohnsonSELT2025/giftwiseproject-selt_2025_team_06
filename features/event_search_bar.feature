As a popular person,
I want to be able to view only events specified by my search parameters.
So that I can view all of the events before a certain date or view all of the events based that have a reasonable budget.

Background
Events have been added to the database, and the user is attending all of them.

Given
The following events exist:

event_name	event_date	event_owner	event_budget
Birthday Party	2025-11-20	Sarah Miller	50
Family Dinner	2025-12-25	James Carter	250
Secret Santa	2025-12-15	Olivia Newton	150

Scenario: Seeing All Events on the Home Page
When I am on the home page
Then I should see all the events I’m registered to

Scenario: Searching events that have a specified event budget
When I am on the home page
Then I mark down a minimum event budget of 20
And I mark down a maximum event budget of 100
Then I should see the following events: Birthday Party
And I should not see the following events: Family Dinner, Secret Santa

Scenario: Searching events based on name, descending order
When I am on the home page
Then I click on the events button in the filter category
And I mark it down in descending order
Then I should see the following events: Birthday Party, Family Dinner, Secret Santa
And I should expect no events to be hidden

Scenario: Searching events based on name, ascending order
When I am on the home page
Then I click on the events button in the filter category
And I mark it down in ascending order
Then I should see the following events: Secret Santa, Family Dinner, Birthday Party
And I should expect no events to be hidden

Scenario: Searching events based on date, descending order
When I am on the home page
Then I click on the date button in the filter category
And I mark it down in descending order
Then I should see the following events: Family Dinner, Secret Santa, Birthday Party
And I should expect no events to be hidden

Scenario: Searching events based on date, ascending order
When I am on the home page
Then I click on the date button in the filter category
And I mark it down in ascending order
Then I should see the following events: Birthday Party, Secret Santa, Family Dinner
And I should expect no events to be hidden