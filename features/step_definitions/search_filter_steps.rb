When("I am on the home page") do
  visit events_path
end

Then("{int} seed events should exist") do |count|
  expect(Event.count).to eq(count)
end

When("I enter a minimum event budget of {int}") do |min|
  fill_in "min_budget", with: min
end

When("I enter a maximum event budget of {int}") do |max|
  fill_in "max_budget", with: max
end

When("I select the event name filter") do
  select "Event Name", from: "sort_filter"
end

When("I select the event date filter") do
  select "Event Date", from: "sort_filter"
end

When("I sort in ascending order") do
  select "Ascending", from: "sort_order"
end

When("I sort in descending order") do
  select "Descending", from: "sort_order"
end

Given(/^the following events exist$/) do |events_table|
  events_table.hashes.each do |row|
    Event.create!(
      title:      row["title"],
      event_date: row["event_date"],
      location:   row["location"],
      budget:     row["budget"],
      theme:      row["theme"],
      user_id:    row["user_id"]
    )
  end
end

Then(/^I should (not )?see the following events: (.*)$/) do |no, event_list|
  event_list.split(',').map(&:strip).each do |event|
    if no
      expect(page.body).not_to include(event)
    else
      expect(page.body).to include(event)
    end
  end
end

Then("I should expect no events to be hidden") do
  Event.pluck(:event_name).each do |event_name|
    expect(page).to have_content(event_name)
  end
end

Then(/^I should see the following events in this order: (.*)$/) do |ordered_list|
  events = ordered_list.split(',').map(&:strip)
  body = page.body

  # First ensure ALL events exist
  events.each do |event|
    expect(body).to include(event), "Expected '#{event}' to be visible on the page"
  end

  # Then check ordering
  events.each_cons(2) do |first, second|
    expect(body.index(first)).to be < body.index(second), "Expected event '#{first}' to appear before '#{second}', but the order was incorrect."
  end
end
