Feature: Reset a password through an email link
  As a GiftWise user who has requested a password reset,
  I want to securely reset my password using the link sent to my email,
  So that I can regain access to my account even if I forgot my password.

  Background:
    Given the following user data exists in the database:
      | email          | username | password  | reset_token | reset_sent_at |
      | test1@test.com | test1    | oldpass1  | VALIDTOKEN  | 5 minutes ago |
    And I have already requested a password reset through the Account Recovery Page

  Scenario: Open Reset Password page with valid token
    When I visit "/recovery/reset?token=VALIDTOKEN"
    Then I should see "Reset Your Password"
    And I should see a password entry field

  Scenario: Open Reset Password page with invalid token
    When I visit "/recovery/reset?token=BADTOKEN"
    Then I should be redirected to the Account Recovery page
    And I should see "Invalid or expired recovery link."

  Scenario: Open Reset Password page with expired token
    Given the user's reset token was sent more than 15 minutes ago
    When I visit "/recovery/reset?token=VALIDTOKEN"
    Then I should be redirected to the Account Recovery page
    And I should see "Invalid or expired recovery link."

  Scenario: Submit blank password
    When I visit "/recovery/reset?token=VALIDTOKEN"
    And I enter "" into the password field
    And I press the Update Password button
    Then I should remain on the Reset Password page
    And I should see "Invalid Password"

  Scenario: Successfully reset password
    When I visit "/recovery/reset?token=VALIDTOKEN"
    And I enter "newsecurepassword" into the password field
    And I press the Update Password button
    Then I should be redirected to the login page
    And I should see "Password Successfully Updated! Please log in."
    And the user's reset_token should be cleared

  Scenario: Token becomes invalid after use
    Given the user has already used their reset link
    When I visit "/recovery/reset?token=VALIDTOKEN"
    Then I should be redirected to the Account Recovery page
    And I should see "Invalid or expired recovery link."
