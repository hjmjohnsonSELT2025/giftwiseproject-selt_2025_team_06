Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password],
      password_confirmation: user[:password],
      first_name: 'Test',
      last_name: 'User',
    )
  end
end

Given(/^that I am logged in with username "(.*)"$/) do |username|
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: '12345678'
  click_button 'Log In'
end

Given(/^that I am on the event creation page$/) do
  visit new_event_path
end

When(/^I attempt to create an event with missing details$/) do
  fill_in 'location', with: 'random location'
  fill_in 'budget', with: '100'
  fill_in 'theme', with: 'random theme'
  click_button 'Create Event'
end

Then(/^I should see an error "(.*)"$/) do |message|
  expect(page).to have_content(message)
end
