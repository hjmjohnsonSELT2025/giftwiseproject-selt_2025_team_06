Given("the following gift ideas exist:") do |table|
  table.hashes.each do |row|
    status = GiftStatus.find_or_create_by(status_name: row["gift_status"])

    Gift.create!(
      name: row["name"],
      price: row["price"],
      purchase_url: row["purchase_url"],
      description: row["description"],
      upvotes: row["upvotes"],
      status_id: status.id,
      creator_id: User.first&.id || FactoryBot.create(:user).id
    )
  end
end

Given("I have assigned recipients to an event") do
  @giver = User.first || FactoryBot.create(:user)
  @recipient = FactoryBot.create(:user)

  @event = Event.create!(
    title: "Holiday Party",
    event_date: Date.today + 10,
    user_id: @giver.id
  )

  GiftGiver.create!(
    event_id: @event.id,
    user_id: @giver.id,
    recipients: [@recipient.id]
  )
end

Given("I am logged in as a gift giver") do
  visit login_path
  fill_in "Username", with: @giver.username
  fill_in "Password", with: @giver.password
  click_button "Login"
end

When("I am viewing that event") do
  visit event_path(@event)
end

When("I select a recipient’s information page") do
  click_link @recipient.username
end

When('I click "Add Gift Idea"') do
  click_link "Add Gift Idea"
end

Then("a form should appear to enter gift idea details") do
  expect(page).to have_selector("form#new_gift_idea")
end

When("I submit a new gift idea named {string}") do |gift_name|
  fill_in "Name", with: gift_name
  fill_in "Price", with: 50
  fill_in "URL", with: "http://example.com"
  fill_in "Description", with: "Some description"
  select "Wishlisted", from: "Status"
  click_button "Save Gift Idea"
end

Then("I should see {string} in the recipient’s gift list") do |gift_name|
  expect(page).to have_content(gift_name)
end

When("I submit the gift idea form without a name") do
  fill_in "Name", with: ""
  click_button "Save Gift Idea"
end

Then('I should see an error "Gift name is required"') do
  expect(page).to have_content("Gift name is required")
end

Then("the gift idea should not be added") do
  expect(Gift.where(name: "").count).to eq(0)
end

When('I click "Edit" for {string}') do |gift_name|
  find("tr", text: gift_name).click_link("Edit")
end

When("I update the description to {string}") do |new_description|
  fill_in "Description", with: new_description
  click_button "Save"
end

When('I click "Remove" for {string}') do |gift_name|
  find("tr", text: gift_name).click_button("Remove")
end

Then('{string} should no longer appear in the recipient’s gift list') do |gift_name|
  expect(page).not_to have_content(gift_name)
end

When('I sort gift ideas by {string}') do |field|
  click_link field
end

When('I filter gift ideas by {string}') do |status|
  select status, from: "Status Filter"
  click_button "Apply"
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

Then('I should see {string} on the page') do |text|
  expect(page).to have_content(text)
end