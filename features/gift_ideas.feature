Feature: Managing gift ideas
  As a gift giver
  I want to browse, sort, vote on, and view gift ideas
  So that I can choose the best presents for my recipients

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

    And I am on the login page

    When I enter Username65 in the username box
    And I enter MyPass65 in the password box
    And I press the “Log In” button
    Then I should be taken to the home page

  Scenario: Viewing all gifts
    When I visit the gifts page
    Then I should see "Bakugan"
    And I should see "Pokemon Cards"
    And I should see "Blanket"

  Scenario: Upvoting a gift
    When I visit the gifts page
    And I upvote "Bakugan"
    Then the vote count for "Bakugan" should increase by 1
    And my vote indicator for "Bakugan" should show that I upvoted it

  Scenario: Downvoting a gift
    When I visit the gifts page
    And I downvote "Blanket"
    Then the vote count for "Blanket" should decrease by 1
    And my vote indicator for "Blanket" should show that I downvoted it

  Scenario: Sorting gifts based on rating
    When I visit the gifts page
    And I sort gifts by "Upvotes (High → Low)"
    Then "Blanket" should appear before "Pokemon Cards"
    And "Pokemon Cards" should appear before "Bakugan"

  Scenario: Sorting gifts based on name
    When I visit the gifts page
    And I sort gifts by "Name (A–Z)"
    Then "Bakugan" should appear before "Blanket"
    And "Blanket" should appear before "Pokemon Cards"

  Scenario: Sorting gifts based on search
    When I visit the gifts page
    And I search for "Poke"
    Then I should see "Pokemon Cards"
    And I should not see "Bakugan"
    And I should not see "Blanket"

  Scenario: Viewing gift
    When I visit the gifts page
    And I click "View Item" for "Bakugan"
    Then I should be on the gift details page for "Bakugan"
    And I should see "$20.00"
    And I should see "Testing"
    And I should see "Open External Link"

  Scenario: Resetting search filters
    When I visit the gifts page
    Given I have applied search or sort filters
    When I click the option to "Reset Filters"
    Then I should see "Bakugan"
    And I should see "Pokemon Cards"
    And I should see "Blanket"
    And no filters should be applied
