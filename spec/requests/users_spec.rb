require "rails_helper"

RSpec.describe "Users Controller", type: :controller do
  let!(:user) {User.create!(username: "testuser", email: "test@example.com", password: "password")}

  describe "DELETE /users/:id" do
    context "with correct username confirmation" do
      it "deletes the use rand redirects to the root" do
        expect{
          delete user_path(user), params: {id: user.id, confirmation_username: "testuser"}
        }.to change(User, :count).by(-1)

        expect (response).to redirect_to(root_path)
        expect(flash[:notice]).to eq( "User deleted successfully.")
      end
    end

    context "with incorrect username confirmation" do
      it "does not delete the user and redirects back" do
        expect{
          delete user_path(user) , params: {id: user.id, confirmation_username: "wrongname"}
        }.not_to change(User, :count)

        expect (response).to redirect_to(users_path(user))
        expect(flash[:alert]).to eq( "User confirmation failed. Account not deleted." )
      end
    end
  end
end