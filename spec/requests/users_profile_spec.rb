require 'rails_helper'

RSpec.describe "Profile Page", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }

  before do
    sign_in user
  end

  describe "GET /users/:id" do
    it "renders the user profile page successfully" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Likes/Dislikes")
    end

    # Ensure the Buttons are on the page
    it "has a change password button" do
      get user_path(user)
      expect(response.body).to include("Change Password")
    end
    it "has a Delete Account Button" do
      get user_path(user)
      expect(response.body).to include("Delete Account")
    end
    it "has a Edit Button" do
      get user_path(user)
      expect(response.body).to include("Edit Account")
    end
  end
end