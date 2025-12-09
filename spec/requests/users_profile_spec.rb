require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }

  describe "GET /users/:id" do
    it "returns a successful response" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
    end

    it "renders the profile page content" do
      get user_path(user)
      expect(response.body).to include("#{user.username}'s Profile")
      expect(response.body).to include("Likes/Dislikes")
      expect(response.body).to include("Hobbies/Occupation")
      expect(response.body).to include("Email/Password")
    end

    it "includes the Edit Account link" do
      get user_path(user)
      expect(response.body).to include("Edit Account")
    end

    it "includes the Change Password button" do
      get user_path(user)
      expect(response.body).to include("Change Password")
    end

    it "includes the Delete Account button" do
      get user_path(user)
      expect(response.body).to include("Delete Account")
    end

    it "includes the Back to Events Page button" do
      get user_path(user)
      expect(response.body).to include("Back to Events Page")
    end
  end
end