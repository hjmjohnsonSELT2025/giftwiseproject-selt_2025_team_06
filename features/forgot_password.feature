Feature: User can Reset their password
  As a Giftwise User that forgot their password,
  I want to reset my password,
  So that I can Log In to my account.

  Background:
    Given the following user exists in the database
      | email           | username   | password  |
      | test1@test.com | test1 | 12345678  |

  Scenario:
