require "rails_helper"

RSpec.describe UserPreference, type: :model do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }
  let(:pref) { Preference.create!(name: "coffee") }

  it "is valid with a user, preference, and category" do
    up = UserPreference.new(user: user, preference: pref, category: "like")
    expect(up).to be_valid
  end

  it "allows only 'like' or 'dislike'" do
    up = UserPreference.new(user: user, preference: pref, category: "maybe")
    expect(up).not_to be_valid
  end

  it "allows the same preference to appear once per category" do
    UserPreference.create!(user: user, preference: pref, category: "like")
    dup = UserPreference.new(user: user, preference: pref, category: "dislike")
  
    expect(dup).to be_valid   # allow one like + one dislike
  end

  it "does not allow duplicates within the same category" do
    UserPreference.create!(user: user, preference: pref, category: "like")
    dup = UserPreference.new(user: user, preference: pref, category: "like")
  
    expect(dup).not_to be_valid
  end

  it "belongs to a user" do
    up = UserPreference.create!(user: user, preference: pref, category: "like")
    expect(up.user).to eq(user)
  end

  it "belongs to a preference" do
    up = UserPreference.create!(user: user, preference: pref, category: "like")
    expect(up.preference).to eq(pref)
  end
end