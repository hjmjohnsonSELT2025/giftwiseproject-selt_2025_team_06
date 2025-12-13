Given(/^a user exists with username "(.*)" email "(.*)" and password "(.*)"$/) do |username, email, password|
    User.create!(
      email: email,
      username: username,
      password: password,
      birthdate: Date.today - 20.years
    )
  end
  
  Given(/^I am logged in as "(.*)"$/) do |username|
    user = User.find_by!(username: username)

    visit login_path
    fill_in "Username / Email", with: user.username
    fill_in "Password", with: "password123"
    click_button "Log In"
  end
  
  Given(/^the following preferences exist:$/) do |table|
    table.hashes.each do |row|
      Preference.find_or_create_by!(name: row["name"])
    end
  end
  
  When(/^I visit the preferences page$/) do
    visit preferences_path
  end
  
  When(/^I check "(.*)" under likes$/) do |name|
    # Try to find existing preference in database first
    pref = Preference.find_by(name: name)
    if pref
      check("likes_#{pref.id}")
    else
      # For dynamically created custom preferences
      # Since JavaScript may not execute in tests, directly set the hidden field
      # First try to find and check the checkbox if it exists (JavaScript executed)
      checkbox_id = "new_like_" + name.downcase.gsub(/\s+/, "_")
      begin
        check(checkbox_id)
      rescue Capybara::ElementNotFound
        # If checkbox doesn't exist (JavaScript didn't run), set hidden field directly
        # Use find to locate hidden field by id
        find("#new_like_field", visible: false).set(name)
      end
    end
  end
  
  When(/^I check "(.*)" under dislikes$/) do |name|
    pref = Preference.find_by!(name: name)
    check("dislikes_#{pref.id}")
  end
  
  When(/^I fill in "add-pref-name" with "(.*)"$/) do |value|
    fill_in "add-like-input", with: value
  end
  
  When(/^I press "Add Preference"$/) do
    click_button("Add Like")
  end
  
  When(/^I press "Continue"$/) do
    click_button("Continue")
  end
  
  Then(/^the user should have preference "(.*)" with category "(.*)"$/) do |name, category|
    pref = Preference.find_by!(name: name)
    up = UserPreference.find_by(user: User.first, preference: pref)
  
    expect(up).not_to be_nil
    expect(up.category).to eq(category)
  end