Feature: View Event Details
    As a user
    I want to view details of a specific event
    So that I can see information appropriate to my role (host, gift giver, or recipient)

    Background: User and event setup
        Given the following user exists in the database:
            | email           | username | password  |
            | host@example.com | hostuser | password123 |
            | giver1@example.com | giver1 | password123 |
            | giver2@example.com | giver2 | password123 |
            | recipient1@example.com | recipient1 | password123 |
            | recipient2@example.com | recipient2 | password123 |
        And an event exists with:
            | title        | event_date | location      | budget | theme      |
            | Birthday Party | 2025-12-25 | New York     | 500.00 | Celebration |

        
    Scenario: Event host views event with all details 
        Given I am logged in with username "hostuser" 
        And the event has gift giver "giver1" with recipients "recipient1, recipient2"
        When I visit the event page
        Then I should see the event title "Birthday Party" 
        And I should see the event date "2025-12-25"
        And I should see the event location "New York" 
        And I should see the event budget "$500.00"
        And I should see the event theme "Celebration"
        And I should see gift giver "giver1"
        And I should see recipients "recipient1, recipient2" for gift giver "giver1"
        And I should see a link "Back to All Events"
        And I should see an invite form
    
    Scenario: Recipient views event with limited details
        Given I am logged in with username "recipient1"
        And the event has gift giver "giver1" with recipients "recipient1, recipient2"
        When I visit the event page
        Then I should see the event title "Birthday Party" 
        And I should see the event date "2025-12-25"
        And I should see that I am assigned to this event
        And I should not see the event location
        And I should not see the event budget
        And I should not see the event theme
        And I should not see any gift giver names
        And I should not see any recipients
        And I should not see an invite form
        And I should see a link "Back to All Events"
    
    Scenario: User who is not involved views event
        Given a user exists with username "outsider" email "outsider@example.com" password "password123"
        And I am logged in with username "outsider" 
        When I visit the event page
        Then I should not be able to access the event
    
    Scenario: Gift giver views event with no recipients assigned
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with no recipients
        When I visit the event page
        Then I should see the event title "Birthday Party"
        And I should see the event date "2025-12-25"
        And I should see the event location "New York"
        And I should see the event budget "$500.00"
        And I should see the event theme "Celebration"
        And I should see gift giver "giver1"
        And I should see "No recipients assigned" for gift giver "giver1"
        And I should see a link "Back to All Events"
        And I should not see an invite form
    
    Scenario: Gift giver views event where they are the only gift giver
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with recipients "recipient1, recipient2"
        When I visit the event page
        Then I should see the event title "Birthday Party"
        And I should see the event date "2025-12-25"
        And I should see the event location "New York"
        And I should see the event budget "$500.00"
        And I should see the event theme "Celebration"
        And I should see gift giver "giver1"
        And I should see recipients "recipient1, recipient2" for gift giver "giver1"
        And I should not see gift giver "giver2"
        And I should see a link "Back to All Events"
        And I should not see an invite form

    Scenario: Gift giver views event with multiple gift givers
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with recipients "recipient1"
        And the event has gift giver "giver2" with recipients "recipient2"
        When I visit the event page
        Then I should see the event title "Birthday Party"
        And I should see all event details
        And I should see gift giver "giver1"
        And I should see gift giver "giver2"
        And I should see recipients "recipient1" for gift giver "giver1"
        And I should see recipients "recipient2" for gift giver "giver2"
        And I should see a link "Back to All Events"
        And I should not see an invite form

    Scenario: Gift giver edits event details successfully
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with recipients "recipient1"
        When I visit the event page
        And I click the edit button
        And I update the event title to "Updated Birthday Party"
        And I update the event location to "Los Angeles"
        And I update the event budget to "750.00"
        And I update the event theme to "Surprise Party"
        And I save the changes
        Then I should see a success message "Event updated successfully"
        And I should see the event title "Updated Birthday Party"
        And I should see the event location "Los Angeles"
        And I should see the event budget "$750.00"
        And I should see the event theme "Surprise Party"

    Scenario: Gift giver edits event with invalid data
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with recipients "recipient1"
        When I visit the event page
        And I click the edit button
        And I update the event title to ""
        And I save the changes
        Then I should see an error message "Please fill out all the fields"
        And I should remain on the edit page

    Scenario: Host edits event details
        Given I am logged in with username "hostuser"
        And the event has gift giver "giver1" with recipients "recipient1"
        When I visit the event page
        And I click the edit button
        And I update the event title to "Host Updated Event"
        And I save the changes
        Then I should see a success message "Event updated successfully"
        And I should see the event title "Host Updated Event"

    Scenario: Recipient cannot edit event details
        Given I am logged in with username "recipient1"
        And the event has gift giver "giver1" with recipients "recipient1"
        When I visit the event page
        Then I should not see an edit button
        And I should not see an edit form

    Scenario: Gift giver edits only the budget
        Given I am logged in with username "giver1"
        And the event has gift giver "giver1" with recipients "recipient1"
        When I visit the event page
        And I click the edit button
        And I update the event budget to "1000.00"
        And I save the changes
        Then I should see the event budget "$1000.00"
        And the event title should remain "Birthday Party"
        And the event location should remain "New York"