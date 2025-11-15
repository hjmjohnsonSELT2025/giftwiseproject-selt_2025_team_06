require 'rails_helper'

RSpec.describe "Landing Page", type: :request do
  describe "GET /" do
    it "renders the landing page successfully" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Welcome to GiftWise")
    end

    it "has a login button" do
      get root_path
      expect(response.body).to include("Login")
    end
  end

  describe "Routing" do
    it "routes root to users#index" do
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Welcome to GiftWise")
    end
  end
end