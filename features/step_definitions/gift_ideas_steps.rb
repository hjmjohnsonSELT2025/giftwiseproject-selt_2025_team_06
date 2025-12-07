Given("the following gift ideas exist:") do |table|
  table.hashes.each do |row|
    status = GiftStatus.find_or_create_by(status_name: row["gift_status"])

    Gift.create!(
      name: row["gift_name"],
      price: row["gift_price"],
      purchase_url: row["gift_url"],
      status_id: status.id
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
    recipients: [@recipient.id] # if using JSON recipients
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
