# ============================================================
#  SEED USERS
# ============================================================

Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password]
    )
  end
end

Then(/(.*) seed users should exist/) do |n_seeds|
  expect(User.count).to eq n_seeds.to_i
end

# ============================================================
#   NAVIGATION
# ============================================================

Given(/^I am on the create account page$/) do
  visit new_user_path
end

# ============================================================
#   FORM INPUT STEPS
# ============================================================

When(/^I enter (.*) in the username box$/) do |username|
  fill_in 'username', with: username
end

When(/^I enter (.*) in the password box$/) do |password|
  fill_in 'password', with: password
end

When(/^I enter (.*) in the hobbies box$/) do |hobbies|
  fill_in 'hobbies', with: hobbies
end

When(/^I enter (.*) in the occupation box$/) do |occupation|
  fill_in 'occupation', with: occupation
end

When(/^I enter "(.*)" in the birthdate box$/) do |dob|
  fill_in 'birthdate', with: birthdate
end
When(/^I enter "(.*)" in the email box$/) do |dob|
  fill_in 'email', with: email
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

Then(/^I should see "(.*)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^I should be taken to the home page$/) do
  expect(current_path).to eq(root_path)
end

Then(/^I should be logged in as (.*)$/) do |username|
  expect(page).to have_content("Logged in as #{username}")
end



