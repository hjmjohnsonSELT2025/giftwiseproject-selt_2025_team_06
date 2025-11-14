
Given("I am on the create account page") do
  visit new_user_path
end


# ============================================================
#   FORM INPUT STEPS
# ============================================================

When(/^I enter "(.*)" in the email box$/) do |email|
  fill_in 'email', with: email
end

When(/^I enter "(.*)" in the username box$/) do |username|
  fill_in 'username', with: username
end

When(/^I enter "(.*)" in the password box$/) do |password|
  fill_in 'password', with: password
end

When(/^I enter "(.*)" in the birthdate box$/) do |dob|
  fill_in 'birthdate', with: dob
end

When(/^I enter "(.*)" in the hobbies box$/) do |hobbies|
  fill_in 'hobbies', with: hobbies
end

When(/^I enter "(.*)" in the occupation box$/) do |occupation|
  fill_in 'occupation', with: occupation
end

# ============================================================
#   BUTTON PRESS
# ============================================================

When(/^I press the "(.*)" button$/) do |button|
  click_button button
end

# ============================================================
#   EXPECTATIONS / OUTCOMES
# ============================================================

Then(/^I should be logged in as "(.*)"$/) do |username|
  expect(page).to have_content("Logged in as #{username}")
end
