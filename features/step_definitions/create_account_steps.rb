Given("I visit the create account page") do
  visit new_user_path
end

# ============================================================
#   FORM INPUT STEPS
# ============================================================

When(/^I enter "(.*)" in the create account email box$/) do |email|
  fill_in 'email', with: email
end

When(/^I enter "(.*)" in the create account username box$/) do |username|
  fill_in 'username', with: username
end

When(/^I enter "(.*)" in the create account password box$/) do |password|
  fill_in 'password', with: password
end

When(/^I enter "(.*)" in the create account birthdate box$/) do |dob|
  fill_in 'birthdate', with: dob
end

When(/^I enter "(.*)" in the create account hobbies box$/) do |hobbies|
  fill_in 'hobbies', with: hobbies
end

When(/^I enter "(.*)" in the create account occupation box$/) do |occupation|
  fill_in 'occupation', with: occupation
end

# ============================================================
#   BUTTON PRESS
# ============================================================

When(/^I press the Create Account button$/) do
  click_button "Create Account"
end