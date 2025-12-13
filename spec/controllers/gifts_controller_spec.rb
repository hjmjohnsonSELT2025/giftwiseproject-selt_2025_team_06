require 'rails_helper'
require 'spec_helper'

RSpec.describe GiftsController, type: :controller do
  let(:user) { User.create!(email: "test@test.com", username: "user1", password: "password") }
  let(:other_user) { User.create!(email: "other@test.com", username: "user2", password: "password") }
  let(:status_default) { GiftStatus.create!(status_name: "Default") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    status_default
  end

  describe 'creating gift' do
    context "with valid parameters" do
      it "creates a gift and redirects" do
        expect {
          post :create, params: {
            gift: {
              name: "New Gift",
              description: "Nice item",
              price: 20,
              purchase_url: "http://example.com"
            }
          }
        }.to change(Gift, :count).by(1)

        expect(response).to redirect_to(gifts_path)
        expect(Gift.last.creator).to eq(user)
        expect(Gift.last.status.status_name).to eq("Default")
      end
    end

    context "with invalid parameters" do
      it "renders :new and does not create a gift" do
        post :create, params: {
          gift: {
            name: "",
            price: 20,
            purchase_url: "http://example.com"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Gift.count).to eq(0)
      end
    end
  end

  describe 'updating gift' do
    let!(:gift) do
      Gift.create!(
        name: "Old Name",
        price: 10,
        purchase_url: "http://item.com",
        status: status_default,
        creator: user
      )
    end

    it "allows the creator to update the gift" do
      patch :update, params: { id: gift.id, gift: { name: "New Name" } }

      expect(response).to redirect_to(gifts_path)
      expect(gift.reload.name).to eq("New Name")
    end

    it "prevents other users from updating the gift" do
      allow(controller).to receive(:current_user).and_return(other_user)

      patch :update, params: { id: gift.id, gift: { name: "Hacked!" } }

      expect(response).to redirect_to(gifts_path)
      expect(gift.reload.name).to eq("Old Name")
    end
  end

  describe 'viewing gifts' do
    let!(:gift1) { Gift.create!(name: "Alpha", price: 10, upvotes: 5, purchase_url: "http://a", status: status_default, creator: user) }
    let!(:gift2) { Gift.create!(name: "Beta", price: 20, upvotes: 10, purchase_url: "http://b", status: status_default, creator: user) }

    it "lists all gifts" do
      get :index
      expect(response).to be_successful
      expect(assigns(:gifts).size).to eq(2)
    end

    it "sorts gifts by upvotes (desc)" do
      get :index, params: { sort: "upvotes" }

      expect(assigns(:gifts).first).to eq(gift2)
      expect(assigns(:gifts).last).to eq(gift1)
    end

    it "filters by search term" do
      get :index, params: { search: "Alpha" }

      expect(assigns(:gifts)).to eq([gift1])
    end

    it "shows a single gift" do
      get :show, params: { id: gift1.id }

      expect(response).to be_successful
      expect(assigns(:gift)).to eq(gift1)
    end
  end

  describe 'removing gift' do
    let!(:gift) do
      Gift.create!(
        name: "DeleteMe",
        price: 15,
        purchase_url: "http://item.com",
        status: status_default,
        creator: user
      )
    end

    it "allows creator to delete gift" do
      expect {
        delete :destroy, params: { id: gift.id }
      }.to change(Gift, :count).by(-1)

      expect(response).to redirect_to(gifts_path)
    end

    it "prevents non-creator from deleting gift" do
      allow(controller).to receive(:current_user).and_return(other_user)

      expect {
        delete :destroy, params: { id: gift.id }
      }.to_not change(Gift, :count)

      expect(response).to redirect_to(gifts_path)
    end
  end

  describe 'voting on gift' do
    let!(:gift) do
      Gift.create!(
        name: "VoteMe",
        price: 10,
        purchase_url: "http://item.com",
        upvotes: 3,
        status: status_default,
        creator: user
      )
    end

    it "increments upvotes" do
      post :upvote, params: { id: gift.id }
      expect(gift.reload.upvotes).to eq(4)
    end

    it "decrements upvotes but not below zero" do
      post :downvote, params: { id: gift.id }
      expect(gift.reload.upvotes).to eq(2)

      3.times { post :downvote, params: { id: gift.id } }

      expect(gift.reload.upvotes).to eq(0)
    end
  end
end
