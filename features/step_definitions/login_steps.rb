Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password],
      password_confirmation: user[:password]
    )
  end
end

Given(/^(?:|I )am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

Then(/(.*) seed users should exist/) do |n_seeds|
  expect(User.count).to eq n_seeds.to_i
end

When(/^I enter (.*) in the username box$/) do |username|
  fill_in 'username', with: username
end

When(/^I enter (.*) in the password box$/) do |password|
  fill_in 'password', with: password
end

When(/^I press the “Log In” button$/) do
  click_button 'Log_In'
end

Then(/^I should be taken to the home page$/) do
  expect(current_path).to eq(events_path)
end

Then(/^I should be taken to the invites page$/) do
  expect(current_path).to eq(invites_path)
end

Then(/^I should be taken to the preferences page$/) do
  expect(current_path).to eq(preferences_path)
end

Then(/^I should be logged in as (.*)$/) do |username|
  user = User.find_by(username: username)
  expect(user).not_to be_nil
end

Then(/^I should remain on the login page$/) do
  expect(current_path).to eq(login_path)
end

Then(/^I should see "(.*)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^I should not see "(.*)"$/) do |message|
  expect(page).not_to have_content(message)
end


