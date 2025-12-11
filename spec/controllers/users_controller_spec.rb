require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(username: "tester", email: "tester@example.com", password: "oldpassword") }

  before do
    # Simulate login by setting session
    session[:user_id] = user.id
  end

  describe "PATCH #update_password" do
    context "with valid current password and matching new passwords" do
      it "updates the password and sends a confirmation email" do
        expect {
          patch :update_password, params: {
            current_password: "oldpassword",
            new_password: "newpassword123",
            confirm_password: "newpassword123"
          }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(flash[:success]).to match(/Password updated successfully/)
        expect(response).to redirect_to(user)
        expect(user.reload.authenticate("newpassword123")).to be_truthy
      end
    end

    context "with incorrect current password" do
      it "does not update and flashes an error" do
        patch :update_password, params: {
          current_password: "wrongpassword",
          new_password: "newpassword123",
          confirm_password: "newpassword123"
        }

        expect(flash[:danger]).to match(/Current password is incorrect/)
        expect(response).to redirect_to(change_password_path)
        expect(user.reload.authenticate("oldpassword")).to be_truthy
      end
    end

    context "with mismatched new passwords" do
      it "does not update and flashes an error" do
        patch :update_password, params: {
          current_password: "oldpassword",
          new_password: "newpassword123",
          confirm_password: "differentpassword"
        }

        expect(flash[:danger]).to match(/New passwords don't match/)
        expect(response).to redirect_to(change_password_path)
      end
    end
  end
end