require "rails_helper"

RSpec.describe PreferencesController, type: :controller do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let!(:coffee) { Preference.create!(name: "coffee") }
  let!(:tea)    { Preference.create!(name: "tea") }

  before { session[:user_id] = user.id }

  describe "GET #index" do
    it "renders successfully" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "assigns all preferences" do
      get :index
      expect(assigns(:preferences)).to include(coffee, tea)
    end
  end

  describe "POST #bulk_save" do
    it "saves likes" do
      post :bulk_save, params: {
        likes: [coffee.id],
        dislikes: []
      }

      up = UserPreference.find_by(user: user, preference: coffee)
      expect(up.category).to eq("like")
    end

    it "saves dislikes" do
      post :bulk_save, params: {
        likes: [],
        dislikes: [tea.id]
      }

      up = UserPreference.find_by(user: user, preference: tea)
      expect(up.category).to eq("dislike")
    end

    it "overwrites older preferences" do
      UserPreference.create!(user: user, preference: coffee, category: "like")

      post :bulk_save, params: {
        likes: [],
        dislikes: [coffee.id]
      }

      up = UserPreference.find_by(user: user, preference: coffee)
      expect(up.category).to eq("dislike")
    end

    it "creates custom like preferences" do
      post :bulk_save, params: {
        likes: [],
        dislikes: [],
        new_like: "matcha"
      }

      pref = Preference.find_by(name: "matcha")
      expect(pref).not_to be_nil

      up = UserPreference.find_by(user: user, preference: pref)
      expect(up.category).to eq("like")
    end

    it "creates custom dislike preferences" do
      post :bulk_save, params: {
        likes: [],
        dislikes: [],
        new_dislike: "anchovies"
      }

      pref = Preference.find_by(name: "anchovies")
      expect(pref).not_to be_nil

      up = UserPreference.find_by(user: user, preference: pref)
      expect(up.category).to eq("dislike")
    end

    it "redirects after saving" do
      post :bulk_save, params: { likes: [], dislikes: [] }
      expect(response).to redirect_to(events_path)
    end
  end
end