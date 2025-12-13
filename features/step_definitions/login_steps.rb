Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password],
      # first_name: user[:first_name],
      # last_name: user[:last_name],
      password_confirmation: user[:password]
    )
  end
end

Given(/^I am logged in as "(.*)"$/) do |username|
  @logged_in_username = username # save for test
  user = User.find_by!(username: username)

  visit login_path
  fill_in "Username / Email", with: user.username
  fill_in "Password", with: "password123"
  click_button "Log In"
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
  click_button 'Log In'
end

Then(/^I should be taken to the home page$/) do
  expect(current_path).to eq(events_path)
end

Then(/^I should be logged in as (.*)$/) do |username|
  # Check session or visible confirmation on the page
  expect(page).to have_content("Welcome back, #{username}!")
end

Then(/^I should remain on the login page$/) do
  expect(current_path).to eq(login_path)
end

Then(/^I should see "(.*)"$/) do |message|
  expect(page).to have_content(message)
end

