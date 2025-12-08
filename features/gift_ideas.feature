Feature: Managing gift ideas
  As a gift giver
  I want to add gift ideas for my recipients
  So that I can keep track of possible presents to buy

  Background:
    Given the following gift ideas exist:
      | name            | price | purchase_url           | description | upvotes | gift_status |
      | Bakugan         | 20    | http://localhost:3000/ | Testing     | 56      | Wishlisted  |
      | Pokemon Cards   | 15    | http://localhost:3000/ | Testing     | 65      | Ignore      |
      | Blanket         | 40    | http://localhost:3000/ | Testing     | 665     | Ignore      |

    And I have assigned recipients to an event
    And I am logged in as a gift giver

  Scenario: Adding a gift idea for a recipient
    When I am viewing that event
    And I select a recipient’s information page
    And I click "Add Gift Idea"
    Then a form should appear to enter gift idea details
    When I submit a new gift idea named "Golf Set"
    Then I should see "Golf Set" in the recipient’s gift list

  Scenario: Fail to add a gift without a name
    When I click "Add Gift Idea"
    And I submit the gift idea form without a name
    Then I should see an error "Gift name is required"
    And the gift idea should not be added

  Scenario: Editing an existing gift idea
    When I am viewing that event
    And I select a recipient’s information page
    And I click "Edit" for "Bakugan"
    And I update the description to "Updated gift idea"
    Then I should see "Updated gift idea" on the page

  Scenario: Removing a gift idea
    When I am viewing that event
    And I select a recipient’s information page
    And I click "Remove" for "Pokemon Cards"
    Then "Pokemon Cards" should no longer appear in the recipient’s gift list

  Scenario: Sorting gift ideas by upvotes
    When I am viewing that event
    And I select a recipient’s information page
    And I sort gift ideas by "Upvotes"
    Then I should see "Blanket" listed before "Pokemon Cards"

  Scenario: Viewing only wishlisted gift ideas
    When I am viewing that event
    And I select a recipient’s information page
    And I filter gift ideas by "Wishlisted"
    Then I should see "Bakugan"
    And I should not see "Pokemon Cards"
    And I should not see "Blanket"
