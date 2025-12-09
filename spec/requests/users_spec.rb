require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password", occupation: "Student", hobbies: "Reading") }

  before do
    post login_path, params: { username: user.username, password: "password" }
  end

  describe "PATCH /users/:id" do
    context "with valid params" do
      it "updates occupation and hobbies" do
        patch user_path(user), params: {
          user: { occupation: "Pharmacist", hobbies: "Swimming" }
        }

        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        user.reload
        expect(user.occupation).to eq("Pharmacist")
        expect(user.hobbies).to eq("Swimming")
        expect(flash[:notice]).to eq("Account updated successfully!")
      end
    end

    context "with invalid params" do
      it "does not update when email is blank" do
        patch user_path(user), params: {
          user: { email: "" }
        }

        expect(response).to redirect_to(user_path(user))
        user.reload
        expect(user.email).to eq("test@example.com")
        expect(flash[:alert]).to eq("Account not updated!")
      end
    end
  end

  describe "DELETE /users/:id" do
    context "with correct username confirmation" do
      it "deletes the user and redirects to login" do
        expect {
          delete user_path(user), params: { confirm_username: "testuser" }
        }.to change(User, :count).by(-1)

        expect(User.find_by(id: user.id)).to be_nil
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("User deleted successfully.")
      end
    end

    context "with incorrect username confirmation" do
      it "does not delete the user and redirects back" do
        expect {
          delete user_path(user), params: { confirm_username: "wrongname" }
        }.not_to change(User, :count)

        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("Username confirmation failed. Account not deleted.")
      end
    end
  end
end