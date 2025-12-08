Feature: Generate Gift Ideas with AI Chatbot
    As a gift giver
    I want to get AI-powered gift suggestions
    So that I can find the perfect gift for event recipient_select

    Background: Users and events have already been added to the database

    Given the following users exists in the database:
      | email           | username   | password  |
      | dilara@example.com | dilara | 12345678  |
      | cj@example.com | cj | 12345678  |

    And the following event exists in the database:
      | title           | event_date   | location  | budget  | theme  | event_creator  |
      | cj's Birthday           | 2025-11-28   | Iowa City  | 1000  | Birthday  | dilara  |


    Scenario: View AI chatbot button on event page
        Given that I am logged in with username "dilara"
        And I am on the event page for "cj's Birthday"
        Then I should see an "AI Gift Ideas" button

    Scenario: Open AI chatbot popup
        Given that I am logged in with username "dilara"
        And I am on the event page for "cj's Birthday"
        When I click the "AI Gift Ideas" button
        Then I should see a chatbot popup interface

    Scenario: Get gift ideas for single recipient automatically
        Given that I am logged in with username "dilara"
        And I am on the event show page for "cj's Birthday"
        And the event has exactly 1 recipient "cj"
        When I open the AI chatbot
        Then I should see gift suggestions for that recipient 
        And the suggestions should be based on the recipient's likes and dislikes 

    Scenario: Select recipient when multiple recipient exist 
        Given that I am logged in with username "dilara"
        And I am on the event show page for "cj's Birthday"
        And the event "cj's Birthday" has 2 or more recipients
        When I open the AI chatbot
        Then I should see a recipient selection dropdown
        When I select a recipient from the dropdown
        Then I should see gift suggestions for the selected recipient

    Scenario: Close chatbot popup
        Given that I am logged in with username "dilara"
        And I am on the event show page for "cj's Birthday"
        And I have opened the AI chatbot
        When I click the close button
        Then the chatbot popup should be closed 

    