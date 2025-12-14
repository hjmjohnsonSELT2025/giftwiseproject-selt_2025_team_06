When(/^I click the "(.*)" link in the navbar$/) do |label|
  within("nav") do
    if page.has_link?(label)
      click_link(label)
    else
      click_button(label)
    end
  end
end

Then(/^I should be taken to the events page$/) do
  expect(current_path).to eq(events_path)
end

Then(/^I should be taken to the profile page for (.*)$/) do |username|
  user = User.find_by(username: username)
  expect(current_path).to eq(user_path(user))
end

Then(/^I should be redirected to the login page$/) do
  expect(current_path).to eq(login_path)
end

# Used for logout testing outside of navbar click
When(/^I log out manually$/) do
  visit logout_path
end

Then(/^I should not see the navbar$/) do
  expect(page).not_to have_css('nav.navbar')
end
