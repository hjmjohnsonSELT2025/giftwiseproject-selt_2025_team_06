require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }

  before do
    post login_path, params: { username: user.username, password: "password" }
  end

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

  end
  describe "DELETE /users/:id" do
    it "deletes the user account when confirmation matches" do
      delete user_path(user), params: { confirm_username: user.username }
      expect(response).to redirect_to(login_path)
      expect(User.exists?(user.id)).to be_falsey
    end

    it "does not delete the user when confirmation fails" do
      delete user_path(user), params: { confirm_username: "wrongname" }
      expect(response).to redirect_to(user_path(user))
      expect(User.exists?(user.id)).to be_truthy
    end
  end
end