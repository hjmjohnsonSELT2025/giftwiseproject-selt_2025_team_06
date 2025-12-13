Given(/the following user exists in the database/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password],
      password_confirmation: user[:password]
    )
  end
end

Given(/^that I am logged in with username "(.*)"$/) do |username|
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: '12345678'
  click_button 'Log_In'
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

When(/^I create an event with title "(.*)"$/) do |title|
  fill_in 'title', with: title
  fill_in 'event_date', with: Date.today
  fill_in 'location', with: 'random location'
  fill_in 'budget', with: '100'
  fill_in 'theme', with: 'random theme'
  click_button 'Create Event'
end

Then(/^I should see an error "(.*)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^I should see a message "(.*)"$/) do |message|
  expect(page).to have_content(message)
end
