Feature: Managing gift ideas
  As a gift giver
  I want to add gift ideas for my recipients
  So that I can keep track of possible presents to buy

  Background:
    Given the following gift ideas exist:
      | gift_name       | gift_price | gift_url                | gift_status |
      | Bakugan         | 20         | http://localhost:3000/  | Wishlisted  |
      | Pokemon Cards   | 15         | http://localhost:3000/  | Ordered     |
      | Blanket         | 40         | http://localhost:3000/  | Delivered   |

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
