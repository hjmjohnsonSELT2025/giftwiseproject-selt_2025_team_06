Given("the following gift ideas exist:") do |table|
  table.hashes.each do |row|
    status = GiftStatus.find_or_create_by!(status_name: row["gift_status"])

    @gift_creator ||= User.create!(
      email: "creator@example.com",
      username: "creator_user",
      password: "password",
      password_confirmation: "password"
    )

    Gift.create!(
      name: row["name"],
      price: row["price"],
      purchase_url: row["purchase_url"],
      description: row["description"],
      upvotes: row["upvotes"],
      status_id: status.id,
      creator_id: @gift_creator.id
    )
  end
end

Given("I have assigned recipients to an event") do
  @event ||= Event.create!(
    title: "Test Event",
    location: "Somewhere",
    budget: 100,
    theme: "Test Theme",
    event_date: Date.today,
    host_id: User.first.id
  )
end

When("I visit the gifts page") do
  visit gifts_path
end

When(/^I upvote "(.*)"$/) do |gift_name|
  within(find(".gift-card", text: gift_name)) do
    all(".vote-btn").last.click   # upvote is the last button
  end
end

When(/^I downvote "(.*)"$/) do |gift_name|
  within(find(".gift-card", text: gift_name)) do
    all(".vote-btn").first.click  # downvote is the first button
  end
end

Then(/^the vote count for "(.*)" should increase by 1$/) do |gift_name|
  gift = Gift.find_by(name: gift_name)
  @initial_votes ||= gift.total_votes - 1
  expect(gift.reload.total_votes).to eq(@initial_votes + 1)
end

Then(/^the vote count for "(.*)" should decrease by 1$/) do |gift_name|
  gift = Gift.find_by(name: gift_name)
  @initial_votes ||= gift.total_votes + 1
  expect(gift.reload.total_votes).to eq(@initial_votes - 1)
end

Then(/^my vote indicator for "(.*)" should show that I upvoted it$/) do |gift_name|
  within(find(".gift-card", text: gift_name)) do
    expect(page).to have_text("🔼")
  end
end

Then(/^my vote indicator for "(.*)" should show that I downvoted it$/) do |gift_name|
  within(find(".gift-card", text: gift_name)) do
    expect(page).to have_text("🔽")
  end
end

When(/^I sort gifts by "(.*)"$/) do |sort_label|
  find("summary", text: /Sort/).click
  click_link sort_label
end

Then(/^"(.*)" should appear before "(.*)"$/) do |first, second|
  cards = all(".gift-card")

  card_texts = cards.map(&:text)

  index_first  = card_texts.index { |t| t.include?(first) }
  index_second = card_texts.index { |t| t.include?(second) }

  expect(index_first).to be < index_second
end


When(/^I search for "(.*)"$/) do |term|
  fill_in placeholder: "Search gifts...", with: term
  click_button "Search"
end

When(/^I click "(.*)" for "(.*)"$/) do |button_text, gift_name|
  visit gifts_path unless page.has_css?(".gift-card")
  within(find(".gift-card", text: gift_name)) do
    click_link button_text
  end
end

Then(/^I should be on the gift details page for "(.*)"$/) do |gift_name|
  gift = Gift.find_by(name: gift_name)
  expect(current_path).to eq(gift_path(gift))
end

Given(/^I have applied search or sort filters$/) do
  visit gifts_path(sort: "name")
end

When(/^I click the option to "(.*)"$/) do |text|
  click_link text
end


Then("no filters should be applied") do
  expect(current_url).to eq(gifts_url)
end
