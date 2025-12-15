# spec/requests/attendees_spec.rb
require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:host) do
    User.create!(username: "host",
                 email: "host@example.com",
                 password: "password")
  end

  let(:event) do
    Event.create!(title: "Holiday Party",
                  event_date: Date.today,
                  location: "Clubhouse",
                  budget: 100,
                  theme: "Festive",
                  host: host)
  end

  let(:giver) do
    User.create!(username: "giver",
                 email: "giver@example.com",
                 password: "password")
  end

  let(:recipient) do
    User.create!(username: "recipient",
                 email: "recipient@example.com",
                 password: "password")
  end

  before do
    post login_path, params: { username: host.username, password: "password" }


    # Set up associations without touching login/session
    GiftGiver.create!(event: event, user: giver)
    Recipient.create!(event: event, user: recipient)
  end

  describe "GET /events/:id/attendees" do
    it "renders the attendees page with gift givers and recipients" do
      get attendees_path(event.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(giver.username)
      expect(response.body).to include(recipient.username)
    end
  end
end