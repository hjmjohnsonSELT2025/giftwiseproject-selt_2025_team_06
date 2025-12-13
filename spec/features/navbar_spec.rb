require 'rails_helper'

RSpec.describe "Navbar behavior", type: :feature do
  let!(:user) { User.create!(
      email: "test@example.com",
      username: "TestUser",
      password: "Password123",
      first_name: "Test",
      last_name: "User"
    )
  }

  before do
    # Log the user in before navbar tests
    visit login_path
    fill_in "username", with: user.username
    fill_in "password", with: "Password123"
    click_button "Log_In"
  end

  describe "navbar visibility" do
    it "shows the navbar when a user is logged in" do
      visit events_path
      expect(page).to have_link("GiftWise")
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")
    end

    it "hides the navbar when the user logs out" do
      click_button "Logout"
      visit login_path
      expect(page).not_to have_css("nav.navbar")
    end
  end

  describe "navbar links routing" do
    it "routes to the events page when clicking GiftWise" do
      click_link "GiftWise"
      expect(current_path).to eq(events_path)
    end

    it "routes to the profile page when clicking Profile" do
      click_link "Profile"
      expect(current_path).to eq(user_path(user.id))
    end

    it "logs out the user when clicking Logout" do
      click_button "Logout"
      expect(current_path).to eq(login_path)
      expect(page).to have_content("You have logged out successfully")
    end
  end
end
