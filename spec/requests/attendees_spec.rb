require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) { User.create!(username: "host", email: "host@example.com", password: "password") }
  let(:event) { Event.create!(title: "Holiday Party", event_date: Date.today, location: "Clubhouse", budget: 100, theme: "Festive", user: user) }
  let(:giver) { User.create!(username: "giver", email: "giver@example.com", password: "password") }
  let(:recipient) { User.create!(username: "recipient", email: "recipient@example.com", password: "password") }

  before do
    GiftGiver.create!(event: event, user: giver, recipients: "[]")
    Invite.create!(event: event, user: recipient, status: "accepted")
  end

  describe "GET /events/:id/attendees" do
    it "renders the attendees page with gift givers and recipients" do
      get attendees_event_path(event)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("giver")
      expect(response.body).to include("recipient")
    end
  end
end