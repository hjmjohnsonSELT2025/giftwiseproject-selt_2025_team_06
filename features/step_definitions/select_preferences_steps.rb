Given(/^a user exists with username "(.*)" email "(.*)" and password "(.*)"$/) do |username, email, password|
    @user_password = password  
    User.create!(
      email: email,
      username: username,
      password: password,
      birthdate: Date.today - 20.years
    )
  end

  Given(/^I am logged in as "testuser"$/) do
    user = User.find_by!(username: "testuser")
    
    visit login_path
    
    if page.current_path == login_path || page.current_path == "/login"
      fill_in "Username / Email", with: user.username
      password_to_use = defined?(@user_password) && @user_password ? @user_password : "password"
      fill_in "Password", with: password_to_use
      click_button "Log In"
      expect(page).not_to have_current_path(login_path, wait: 5)
    else
      expect(page).not_to have_current_path(login_path)
    end
  end
  
  Given(/^the following preferences exist:$/) do |table|
    table.hashes.each do |row|
      Preference.find_or_create_by!(name: row["name"])
    end
  end
  
  When(/^I visit the preferences page$/) do
    visit preferences_path
    expect(page).to have_current_path(preferences_path, wait: 5)
  end
  
  When(/^I check "(.*)" under likes$/) do |name|
    pref = Preference.find_by(name: name)
    if pref
      checkbox_id = "likes_#{pref.id}"
      expect(page).to have_field(checkbox_id, wait: 5)
      check(checkbox_id)
    else
      checkbox_id = "new_like_" + name.downcase.gsub(/\s+/, "_")
      expect(page).to have_field(checkbox_id, wait: 10)
      check(checkbox_id)
    end
  end
  
  When(/^I check "(.*)" under dislikes$/) do |name|

    expect(page).to have_content(name, wait: 5)
    
    pref = Preference.find_by!(name: name)

    begin
      checkbox_id = "dislikes_#{pref.id}"
      expect(page).to have_field(checkbox_id, wait: 2)
      check(checkbox_id)
    rescue Capybara::ElementNotFound
      within("#dislikes-list") do
        find("label", text: /#{Regexp.escape(name)}/i).find("input[type='checkbox']").check
      end
    end
  end
  
  When(/^I fill in "add-pref-name" with "(.*)"$/) do |value|
    expect(page).to have_field("add-like-input", visible: true, wait: 10)
    fill_in "add-like-input", with: value
  end
  
  When(/^I press "Add Preference"$/) do
    click_button("Add Like")
  end
  
  When(/^I press "Continue"$/) do
    click_button("Continue")
    expect(page).to have_current_path(events_path, wait: 5)
  end
  
  Then(/^I should see "Preferences saved!"$/) do
    expect(page).to have_current_path(events_path)
  end

  Then(/^the user should have preference "(.*)" with category "(.*)"$/) do |name, category|
    pref = Preference.find_by!(name: name)
    user = User.find_by!(username: "testuser")
    up = UserPreference.find_by(user: user, preference: pref)
  
    expect(up).not_to be_nil
    expect(up.category).to eq(category)
  end