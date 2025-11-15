require 'rails_helper'

RSpec.describe "UserItems", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/user_items/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/user_items/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/user_items/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
