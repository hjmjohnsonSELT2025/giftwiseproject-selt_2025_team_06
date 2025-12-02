require "rails_helper"

RSpec.describe "User Preferences", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }

  before do
    post login_path, params: { username: user.username, password: "password" }
  end

  describe "GET /preferences" do
    it "renders the preferences page" do
      get preferences_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Likes")
      expect(response.body).to include("Dislikes")
    end
  end

  describe "POST /preferences/bulk_save" do
    let!(:coffee) { Preference.create!(name: "coffee") }
    let!(:tea)    { Preference.create!(name: "tea") }
    let!(:lego)   { Preference.create!(name: "lego") }

    def post_form(params)
      post bulk_save_preferences_path,
           params: params.merge({ commit: "Continue" })
    end

    it "saves a like preference" do
      post_form({
        "likes" => [coffee.id.to_s],
        "dislikes" => nil,
        "new_like" => "",
        "new_dislike" => ""
      })

      up = UserPreference.find_by(user: user, preference: coffee)
      expect(up).not_to be_nil
      expect(up.category).to eq("like")
    end

    it "saves a dislike preference" do
      post_form({
        "likes" => nil,
        "dislikes" => [tea.id.to_s],
        "new_like" => "",
        "new_dislike" => ""
      })

      up = UserPreference.find_by(user: user, preference: tea)
      expect(up).not_to be_nil
      expect(up.category).to eq("dislike")
    end

    it "creates and saves a custom like" do
      post_form({
        "likes" => nil,
        "dislikes" => nil,
        "new_like" => "matcha",
        "new_dislike" => ""
      })

      pref = Preference.find_by(name: "matcha")
      expect(pref).not_to be_nil

      up = UserPreference.find_by(user: user, preference: pref)
      expect(up).not_to be_nil
      expect(up.category).to eq("like")
    end

    it "creates and saves a custom dislike" do
      post_form({
        "likes" => nil,
        "dislikes" => nil,
        "new_like" => "",
        "new_dislike" => "spicy food"
      })

      pref = Preference.find_by(name: "spicy food")
      expect(pref).not_to be_nil

      up = UserPreference.find_by(user: user, preference: pref)
      expect(up).not_to be_nil
      expect(up.category).to eq("dislike")
    end

    it "removes all old preferences before saving new ones" do
      post_form({
        "likes" => [coffee.id.to_s],
        "dislikes" => nil,
        "new_like" => "",
        "new_dislike" => ""
      })
      expect(UserPreference.count).to eq(1)

      post_form({
        "likes" => nil,
        "dislikes" => [tea.id.to_s],
        "new_like" => "",
        "new_dislike" => ""
      })

      expect(UserPreference.count).to eq(1)
      expect(UserPreference.first.preference).to eq(tea)
      expect(UserPreference.first.category).to eq("dislike")
    end

    it "assigns only one category per preference" do
      post_form({
        "likes" => [coffee.id.to_s],
        "dislikes" => [coffee.id.to_s],
        "new_like" => "",
        "new_dislike" => ""
      })

      up = UserPreference.find_by(user: user, preference: coffee)
      expect(up).not_to be_nil
      expect(%w[like dislike]).to include(up.category)
    end
  end
end