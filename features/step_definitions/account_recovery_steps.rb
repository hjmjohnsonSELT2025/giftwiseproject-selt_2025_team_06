#  STEPS

# When
When("I enter {string} into the identifier box") do |identifier|
  fill_in "identifier", with: identifier
end

When("I press the Send Recovery Instructions button") do
  click_button "SEND RECOVERY INSTRUCTIONS"
end

# Then
Then("I should stay on the Account Recovery page") do
  expect(page).to have_current_path(forgot_path)
end

Then("I should be redirected to the login page") do
  expect(page).to have_current_path(login_path)
end
