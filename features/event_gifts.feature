Feature: Getting gifts for events
  As a gift giver
  I want to select from a select number of gifts based on my recipient
  So that I can get the best gift for them while staying in budget

  Background:
    Given the following gift ideas exist:
      | name            | price | purchase_url           | description | upvotes | gift_status |
      | Bakugan         | 20    | http://localhost:3000/ | Testing     | 56      | Wishlisted  |
      | Pokemon Cards   | 15    | http://localhost:3000/ | Testing     | 65      | Ignore      |
      | Blanket         | 40    | http://localhost:3000/ | Testing     | 665     | Ignore      |

    And the following users exist:
      | email           | username   | password  |
      | user65@mojo.com | Username65 | MyPass65  |
      | user32@mojo.com | Username32 | MyPass32  |
      | user40@mojo.com | Username40 | MyPass40  |

    And the following events exist:
      | title              | event_date | location        | budget | host_username |
      | Birthday Bash      | 2025-12-20 | Iowa City       | 50.00  | Username65    |
      | Holiday Exchange   | 2025-12-25 | Cedar Rapids    | 30.00  | Username32    |
      | Secret Santa Night | 2025-12-18 | Des Moines      | 40.00  | Username40    |

    And I am on the login page

    When I enter Username65 in the username box
    And I enter MyPass65 in the password box
    And I press the “Log In” button
    Then I should be taken to the home page

  Scenario: Viewing assigned recipients for gift giving
    When I visit the events page
    And I click View Event for Birthday Bash
    And I am assigned to give gifts at an event
    When I view my gift assignments
    Then I should see the list of recipients I am responsible for

  Scenario: Having no recipients assigned
    When I visit the events page
    And I click View Event for Birthday Bash
    And I have no gift assignments for the event
    When I view my gift assignments
    Then I should see "You have no assigned recipients for this event."

  Scenario: Selecting a recipient to choose a gift for
    When I visit the events page
    And I click View Event for Birthday Bash
    And I am assigned to give a gift to "Username32"
    When I choose to select a gift for "Username32"
    Then I should see gift suggestions for "Username32"

  Scenario: Viewing wishlisted gift options within budget
    When I visit the events page
    And I click View Event for Birthday Bash
    And I am choosing a gift for "Username32"
    And "Username32" has wishlisted some gifts
    When I choose to select a gift for "Username32"
    Then I should see wishlisted gifts for "Username32" that are within the event budget

  Scenario: Ignored gifts are excluded from suggestions
    When I visit the events page
    And I click View Event for Birthday Bash
    And I am choosing a gift for "Username32"
    And "Username32" has ignored certain gifts
    When I choose to select a gift for "Username32"
    Then I should not see any ignored gifts for "Username32"

  Scenario: Assigning a gift to a recipient
    When I visit the events page
    And I click View Event for Birthday Bash
    And I am choosing a gift for "Username32"
    When I choose to select a gift for "Username32"
    And I assign a gift to "Username32"
    Then the gift should be assigned to that recipient
    And I should see a confirmation message

  Scenario: Removing a previously assigned gift
    When I visit the events page
    And I click View Event for Birthday Bash
    And a gift is already assigned to "Username32"
    When I remove the gift assignment
    Then "Username32" should no longer have a gift assigned