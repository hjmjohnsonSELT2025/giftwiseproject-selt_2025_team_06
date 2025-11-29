#  STEPS

# When
When("I enter {string} into the identifier box") do |identifier|
  fill_in "identifier", with: identifier
end

When("I press the Send Recovery Instructions button") do
  click_button "Send Recovery Instructions"
end

# Then
Then("I should stay on the Account Recovery page") do
  expect(page).to have_current_path(recovery_path)
end

