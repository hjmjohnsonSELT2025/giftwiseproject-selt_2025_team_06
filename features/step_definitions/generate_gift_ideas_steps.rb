Given(/^I am logged in as user "(.*)"$/) do |username|
  visit login_path
  fill_in 'username', with: username
  fill_in 'password', with: '12345678'
  click_button 'LOGIN'
end

Given(/^the following users are created in the database:$/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user[:email],
      username: user[:username],
      password: user[:password],
      password_confirmation: user[:password]
    )
  end
end
  
Given(/^I navigate to the event (show )?page for "(.*)"$/) do |page_type, event_title|
    event = Event.find_by(title: event_title)
    if event.nil?
      raise "Event with title '#{event_title}' not found"
    end
    
    visit event_path(event)
  end
  
Given(/^the event has exactly (\d+) recipient "(.*)"$/) do |count, recipient_name|
    event_id = current_path.split('/').last
    event = Event.find(event_id)

    recipient = User.find_by(username: recipient_name)
    if recipient.nil?
      raise "Recipient with username '#{recipient_name}' not found"
    end

    Recipient.find_or_create_by(
      event: event,
      user: recipient
    )
  end
  

Given(/^the event "(.*)" has (\d+) or more recipients$/) do |event_title, min_count|
    event = Event.find_by(title: event_title)
    if event.nil?
      raise "Event with title '#{event_title}' not found"
    end
    
    current_count = event.recipients.count
    
    if current_count < min_count.to_i
      needed = min_count.to_i - current_count
      needed.times do |i|
        recipient = User.create!(
          email: "recipient#{Time.now.to_i}#{i}@test.com",
          username: "recipient#{Time.now.to_i}#{i}",
          password: "password123",
          password_confirmation: "password123",
          likes: '["books", "coffee"]',
          dislikes: '["chocolate"]'
        )
        Recipient.find_or_create_by(
          event: event,
          user: recipient
        )
      end
    end
  end
  

When(/^I click the "(.*)" button$/) do |button_text|
    click_button button_text
  end
  

When(/^I open the AI chatbot$/) do
    click_button "AI Gift Ideas"
  end
  

When(/^I select a recipient from the dropdown$/) do
    select = find('#recipient_select')
    options = select.all('option').reject { |opt| opt.value.blank? }
    if options.any?
      select.select(options.first.text)
    else
      raise "No recipients available in dropdown"
    end
  end
  

When(/^I click the close button$/) do
    find('.chatbot-close, #chatbot-close-btn').click
  end

Then(/^I should see an "(.*)" button$/) do |button_text|
    expect(page).to have_button(button_text, visible: :all)
  end
  
Then(/^I should see a chatbot popup interface$/) do
    expect(page).to have_css('#chatbot-popup.show', visible: true, wait: 5)
    expect(page).to have_css('.chatbot-container', visible: true)
    expect(page).to have_css('.chatbot-header', visible: true)
  end

Then(/^I should see gift suggestions for that recipient$/) do
    expect(page).to have_css('.chatbot-messages, #chatbot-messages')
    expect(page).to have_content(/gift|suggestion|idea/i)
end 

Then(/^I should see a recipient selection dropdown$/) do
    expect(page).to have_select('recipient_select', visible: true)
end

Then(/^I should see gift suggestions for the selected recipient$/) do
    expect(page).to have_css('.chatbot-messages, #chatbot-messages')
    expect(page).to have_content(/gift|suggestion|idea/i)
end

Then(/^the suggestions should be based on the recipient's likes and dislikes$/) do
    expect(page).to have_content(/like|dislike|preference/i)
end
  
Then(/^the chatbot popup should be closed$/) do
    expect(page).not_to have_css('.chatbot-popup.show, #chatbot-popup.show')
end
  
Given(/^I have opened the AI chatbot$/) do
    click_button "AI Gift Ideas"
    expect(page).to have_css('.chatbot-popup.show, #chatbot-popup.show', visible: true, wait: 5)
end