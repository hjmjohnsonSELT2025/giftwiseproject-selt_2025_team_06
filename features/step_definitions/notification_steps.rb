Given(/the following event exists in the database/) do |events_table|
  events_table.hashes.each do |event|
    event_creator = User.find_by(username: event['event_creator'])
    Event.create!(
      title: event['title'],
      event_date: event['event_date'],
      location: event['location'],
      budget: event['budget'],
      theme: event['theme'],
      user_id: event_creator.id
    )
  end
end

Given(/^user "(.*)" has invited "(.*)" to the event "(.*)"$/) do |inviter_usr_name, invitee_usr_name, event_title|
  inviter = User.find_by(username: inviter_usr_name)
  invitee = User.find_by(username: invitee_usr_name)
  event = Event.find_by(title: event_title, user_id: inviter.id)

  Invite.create(
    event_id: event.id,
    user_id: invitee.id,
    status: "pending"
  )
end

Given(/^that I am on the home page$/) do
  visit events_path
end

Given(/^that I am on the notifications page$/) do
  visit invites_path
end

Given(/^that I can see an invite listed for "(.*)"$/) do |event_title|
  expect(page).to have_content(event_title)
end

When(/^I press the "([^"]*)" button$/) do |button_name|
  click_on(button_name)
end

Then(/^I should see an invite listed for "(.*)"$/) do |event_title|
  expect(page).to have_content(event_title)
end

Then(/^I should see the event "(.*)" on the dashboard$/) do |event_title|
  expect(page).to have_content(event_title)
end
