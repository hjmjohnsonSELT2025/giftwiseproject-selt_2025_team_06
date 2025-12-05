When('I press "Remove Attendee" next to {string}') do |username|
  within("#attendee-#{username}") do
    find("input[type=submit][value='Remove Attendee']").click
  end
end

Then('{string} should no longer be attending the event {string}') do |username, event_name|
  user = User.find_by(username: username)
  event = Event.find_by(title: event_name)

  expect(Invite.exists?(user: user, event: event)).to be false
end

And(/^user "([^"]*)" has invited "([^"]*)" who accepted to the event "([^"]*)"$/) do |host, attendee, event_name|
  host_user = User.find_by!(username: host)
  attendee_user = User.find_by!(username: attendee)
  event = Event.find_by!(title: event_name, user_id: host_user.id)

  invite = Invite.create!(
    user: attendee_user,
    event: event,
    status: "accepted"
  )

end