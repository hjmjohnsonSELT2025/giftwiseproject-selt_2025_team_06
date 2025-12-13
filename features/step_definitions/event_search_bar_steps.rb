# features/step_definitions/event_search_bar_steps.rb

Given(/^the following events exist:$/) do |table|
  table.hashes.each do |row|
    owner = User.find_by(username: row["event_owner"].parameterize)

    unless owner
      owner = User.create!(
        username: row["event_owner"].parameterize,
        email: "#{row['event_owner'].parameterize}@example.com",
        password: "password",
        password_confirmation: "password",
        birthdate: Date.today - 30.years
      )
    end

    Event.create!(
      title: row["event_name"],
      event_date: row["event_date"],
      budget: row["event_budget"],
      location: "Test Location",
      theme: "Test Theme",
      user: owner
    )
  end
end



Given(/^I am currently logged in as "(.*)"$/) do |username|
  visit login_path
  fill_in "username", with: username
  fill_in "password", with: "password"
  click_button "Log_In"
end

Given(/^I am registered for all events$/) do
  user = User.find_by!(username: "testuser")

  Event.find_each do |event|
    GiftGiver.find_or_create_by!(
      user: user,
      event: event
    )
  end
end


When("I enter a minimum budget of {int}") do |min|
  fill_in "min_budget", with: min
end

When("I enter a maximum budget of {int}") do |max|
  fill_in "max_budget", with: max
end
When('I enter "{string}" into the search title field') do |query|
  fill_in "Search Title", with: query
end

When('I select "{word}" as the sort criterion') do |criterion|
  select criterion, from: "sort_by"
end

When('I select "{word}" order') do |order|
  select order, from: "direction"
end

When("I apply the filters") do
  click_button "Apply Filters"
end

Then("I should see the following events:") do |table|
  table.raw.flatten.each do |event_title|
    expect(page).to have_content(event_title)
  end
end

Then("I should not see the following events:") do |table|
  table.raw.flatten.each do |event_title|
    expect(page).not_to have_content(event_title)
  end
end

Then("I should see the events in the following order:") do |table|
  titles = table.raw.flatten
  page_text = page.text

  titles.each_cons(2) do |first, second|
    expect(page_text.index(first)).to be < page_text.index(second)
  end
end

And('I enter {string} into the search title field') do |query|
  fill_in "title", with: query
end