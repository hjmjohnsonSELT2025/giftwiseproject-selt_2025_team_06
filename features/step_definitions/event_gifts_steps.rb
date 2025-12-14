Given(/the following events exist/) do |events_table|
  events_table.hashes.each do |event|
    host = User.find_by!(username: event[:host_username])

    Event.create!(
      title: event[:title],
      event_date: event[:event_date],
      location: event[:location],
      budget: event[:budget],
      user_id: host.id,
      host_id: host.id
    )
  end
end

Given(/^I am assigned to give gifts at an event$/) do
  @event = Event.first
  GiftGiver.create!(
    event: @event,
    user: User.find_by!(username: "Username65"),
    recipient: User.find_by!(username: "Username32")
  )
end

Given(/^I have no gift assignments for the event$/) do
  @event = Event.first
  GiftGiver.where(
    event: @event,
    user: User.find_by!(username: "Username65")
  ).destroy_all
end

When(/^I view my gift assignments$/) do
  visit event_path(@event)
end

Then(/^I should see the list of recipients I am responsible for$/) do
  expect(page).to have_css("li", text: "Username32")
end

Given(/^I am assigned to give a gift to "(.*)"$/) do |recipient_name|
  @event = Event.first
  recipient = User.find_by!(username: recipient_name)

  GiftGiver.create!(
    event: @event,
    user: User.find_by!(username: "Username65"),
    recipient: recipient
  )
end

When(/^I choose to select a gift for "(.*)"$/) do |recipient_name|
  @event ||= Event.first
  recipient = User.find_by!(username: recipient_name)
  visit add_event_gift_path(@event.id, recipient_id: recipient.id)
end

Then(/^I should see gift suggestions for "(.*)"$/) do |recipient_name|
  expect(page).to have_content("Gift Ideas for #{recipient_name}")
end

Given(/^"(.*)" has wishlisted some gifts$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)
  wishlist = GiftStatus.find_by!(status_name: "Wishlisted")
  gift = Gift.first

  UserGiftStatus.create!(
    user: recipient,
    gift: gift,
    status: wishlist
  )
end

Given(/^"(.*)" has ignored certain gifts$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)
  ignored = GiftStatus.find_by!(status_name: "Ignore")
  gift = Gift.last

  UserGiftStatus.create!(
    user: recipient,
    gift: gift,
    status: ignored
  )
end

When(/^I view gift suggestions$/) do
  expect(page).to have_content("Wishlisted Options")
end

Then(/^I should see wishlisted gifts for "(.*)" that are within the event budget$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)
  event = @event || Event.first
  budget = event.budget.to_f

  wishlisted = Gift
                 .joins(:user_gift_statuses)
                 .joins("INNER JOIN gift_statuses ON gift_statuses.id = user_gift_statuses.status_id")
                 .where(user_gift_statuses: { user_id: recipient.id })
                 .where(gift_statuses: { status_name: "Wishlisted" })
                 .where("price <= ?", budget)

  expect(page).to have_content("Wishlisted Options")

  wishlisted.each do |gift|
    expect(page).to have_content(gift.name)
  end
end

Then(/^I should not see any ignored gifts for "(.*)"$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)

  ignored = Gift
              .joins(:user_gift_statuses)
              .joins("INNER JOIN gift_statuses ON gift_statuses.id = user_gift_statuses.status_id")
              .where(user_gift_statuses: { user_id: recipient.id })
              .where(gift_statuses: { status_name: "Ignore" })

  ignored.each do |gift|
    expect(page).not_to have_content(gift.name)
  end
end

When(/^I assign a gift to "(.*)"$/) do |recipient_name|
  @event ||= Event.first
  recipient = User.find_by!(username: recipient_name)
  user = User.find_by!(username: "Username65")

  # Ensure assignment exists (idempotent)
  GiftGiver.find_or_create_by!(
    event: @event,
    user: user,
    recipient: recipient
  )

  click_button "Assign This Gift", match: :first

  @gift_assignment = GiftGiver.find_by!(
    event: @event,
    user: user,
    recipient: recipient
  )
end

Then(/^the gift should be assigned to that recipient$/) do
  expect(@gift_assignment.gift).not_to be_nil
end

Then(/^I should see a confirmation message$/) do
  expect(page).to have_content("Gift assigned successfully!")
end

Given(/^a gift is already assigned to "(.*)"$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)
  gift = Gift.first

  @gift_assignment = GiftGiver.find_or_create_by!(
    event: Event.first,
    user: User.find_by!(username: "Username65"),
    recipient: recipient
  )

  @gift_assignment.update!(gift: gift)
end

When(/^I choose to change the gift$/) do
  expect(page).to have_link("Change Gift")
end

When(/^I remove the gift assignment$/) do
  visit event_path(Event.first)
  click_button "Remove Gift"
end

And(/^I am choosing a gift for "(.*)"$/) do |recipient_name|
  @event ||= Event.first
  recipient = User.find_by!(username: recipient_name)

  visit select_gift_event_path(@event.id, recipient.id)
end

Then(/^"(.*)" should no longer have a gift assigned$/) do |recipient_name|
  recipient = User.find_by!(username: recipient_name)
  assignment = GiftGiver.find_by(
    event: Event.first,
    user: User.find_by!(username: "Username65"),
    recipient: recipient
  )

  expect(assignment.gift).to be_nil
end

Then(/^I should be able to select a different gift$/) do
  expect(page).to have_button("Assign This Gift")
end

When("I visit the events page") do
  visit root_path
end

And(/^I click View Event for (.*)$/) do |event_title|
  event = Event.find_by!(title: event_title)
  visit event_path(event)
end
