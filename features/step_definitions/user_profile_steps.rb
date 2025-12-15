When("I visit my profile page") do
  @user ||= User.find_by!(username: @logged_in_username)
  visit user_path(@user)
end

When("I click {string}") do |button_text|
  click_button button_text
end

When("I click the Delete Account trigger") do
  find("#delete-acct-btn").click
end

Then("I should see {string} in a popup") do |text|
  expect(page).to have_content(text)
end

Then("I should be taken to the change password page") do
  expect(current_path).to eq(change_password_path) # adjust to your actual route
  expect(page).to have_content("Change Password")
end

When("I confirm deletion with {string}") do |username|
  fill_in "confirm_username", with: username
  find("#deletePopup .btn-danger").click
end

Then("my account should be deleted") do
  expect(User.exists?(@user.id)).to be_falsey
end

Then("I should be on the events page") do
  expect(current_path).to eq(events_path)
end