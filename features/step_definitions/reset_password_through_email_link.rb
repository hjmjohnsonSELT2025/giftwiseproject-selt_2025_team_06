# features/step_definitions/reset_password_steps.rb

# ============================
# Reset Password Step Definitions
# ============================

Given("I have already requested a password reset through the Account Recovery Page") do
  # No action needed — Background table already handles setup.
end

Given("the following user data exists in the database:") do |table|
  table.hashes.each do |row|

    # Convert "5 minutes ago" / "20 minutes ago" → proper Time objects ChatGPT 5.1 Helped me fix this step to work
    reset_time =
      if row["reset_sent_at"].to_s.include?("minutes ago")
        amount = row["reset_sent_at"].to_i
        amount.minutes.ago
      else
        row["reset_sent_at"] # fallback
      end

    User.create!(
      email: row["email"],
      username: row["username"],
      password: row["password"],
      reset_token: row["reset_token"],
      reset_sent_at: reset_time
    )
  end
end

When("I visit {string}") do |path|
  visit path
end

Then("I should see a password entry field") do
  expect(page).to have_field("password")
end

Then("I should be redirected to the Account Recovery page") do
  expect(page).to have_current_path(recovery_path)
end

Then("the user's new password should be {string}") do |expected_password|
  user = User.find_by(username: "test1")
  expect(user.authenticate(expected_password)).to be_truthy
end

Given("the user's reset token was sent more than 15 minutes ago") do
  user = User.find_by(username: "test1")
  user.update(reset_sent_at: 20.minutes.ago)
end

When("I enter {string} into the password field") do |password|
  fill_in "password", with: password
end

When("I press the Update Password button") do
  click_button "Update Password"
end

Then("I should remain on the Reset Password page") do
  expect(page.current_path).to start_with("/recovery/reset")
end

Then("the user's reset_token should be cleared") do
  user = User.find_by(username: "test1")
  expect(user.reset_token).to be_nil
end

Given("the user has already used their reset link") do
  user = User.find_by(username: "test1")
  user.update(reset_token: nil)
end
