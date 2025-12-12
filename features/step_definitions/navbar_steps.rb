When(/^I click the "(.*)" link in the navbar$/) do |link_text|
  within('nav.navbar') do
    click_on link_text
  end
end

Then(/^I should be taken to the events page$/) do
  expect(current_path).to eq(events_path)
end

Then(/^I should be taken to the (.*) page for (.*)$/) do |page_type, username|
  user = User.find_by(username: username)

  expected_path =
    case page_type.downcase
    when "profile"
      user_path(user)
    when "invites"
      invites_path
    else
      raise "Unknown page type: #{page_type}"
    end

  expect(current_path).to eq(expected_path)
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
