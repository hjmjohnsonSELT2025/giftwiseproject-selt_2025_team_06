Then(/^I should see the closest upcoming event displayed in the footer$/) do
  upcoming_event = Event.where("event_date >= ?", Date.today).order(:event_date).first

  within("footer") do
    if upcoming_event
      expect(page).to have_content(upcoming_event.title)
      expect(page).to have_content(upcoming_event.event_date.strftime("%Y-%m-%d"))
    else
      raise "No upcoming event exists in the database to compare with."
    end
  end
end

Then(/^I should see how many days remain until my nearest event in the footer$/) do
  upcoming_event = Event.where("event_date >= ?", Date.today).order(:event_date).first
  days_remaining = (upcoming_event.event_date - Date.today).to_i

  within("footer") do
    expect(page).to have_content(days_remaining)
    expect(page).to have_content("days")
  end
end

Given(/^I have no upcoming events$/) do
  Event.destroy_all
end

Then(/^I should see a message indicating that no events are scheduled$/) do
  within("footer") do
    expect(page).to have_content("No upcoming events scheduled")
  end
end

Then(/^I should see a gift planning tip displayed in the footer$/) do
  within("footer") do
    expect(page).to have_css(".gift-tip")
  end
end

Then(/^I should see a different gift planning tip in the footer$/) do
  first_tip = find("footer .gift-tip").text
  visit current_path
  second_tip = find("footer .gift-tip").text
  expect(second_tip).not_to eq(first_tip)
end

Then(/^I should not see any gift planning tips in the footer$/) do
  within("footer") do
    expect(page).not_to have_css(".gift-tip")
  end
end

Then(/^I should see a link to the support or help page in the footer$/) do
  within("footer") do
    expect(page).to have_link("Support")
  end
end

Then(/^I should see support contact information in the footer$/) do
  within("footer") do
    expect(page).to have_content("Contact Support")
    expect(page).to have_content("@") # email or similar
  end
end

Then(/^the help or support section in the footer should be clearly labeled$/) do
  within("footer") do
    expect(page).to have_content("Help")
    expect(page).to have_content("Support")
  end
end

When(/^I am logged in as (.+) with password (.+)$/) do |email, password|
  visit login_path
  fill_in "username", with: email
  fill_in "password", with: password
  click_button "LOGIN"

  user = User.find_by(username: email)
  expect(page).to have_current_path(events_path)
end


When(/^I am logged out$/) do
  visit logout_path
  expect(page).to have_current_path(login_path)
  expect(session[:user_id]).to be_nil
end