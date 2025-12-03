Given('user "{string}" has invited "{string}" to the event "{string}"') do |host, attendee, event|
  event = Event.find_by(title: event)
  attendee = User.find_by(username: attendee)

  Invite.create!(user: attendee, event: event, status: "accepted")
end

When('I press "Remove Attendee" next to {string}') do |username|
  within("#attendee-#{username}") do
    click_button "Remove Attendee"
  end
end

Then('{string} should no longer be attending the event {string}') do |username, event_name|
  user = User.find_by(username: username)
  event = Event.find_by(title: event_name)

  expect(Invite.exists?(user: user, event: event)).to be_falsey
end