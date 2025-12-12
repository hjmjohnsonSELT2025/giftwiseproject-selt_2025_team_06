require 'rails_helper'
require_relative '../../app/services/ai_service'

RSpec.describe Events::GiftIdeasController, type: :controller do
    let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password123") }
    let(:recipient) {
        User.create!(username: "recipient", email: "recipient@example.com", password: "password123", likes: '["books", "coffee"]', dislikes: '["chocolate"]')
    }
    let(:event) {
        Event.create!(
            title: "Test Event",
            event_date: Date.today + 30,
            location: "Test Location",
            budget: 100,
            theme: "Test Theme",
            user_id: user.id
        )
    }
    let(:gift_giver) {
        GiftGiver.create!(
            event: event,
            user: user,
            recipients: "[#{recipient.id}]"
        )
    }

    before do
        session[:user_id] = user.id
    end

    describe "GET #recipients" do
        context "with valid event and gift giver" do
            before do
                gift_giver  # Ensure gift_giver is created
            end
            
            it "returns recipient information" do
                get :recipients, params: { event_id: event.id }, format: :json
                expect(response).to have_http_status(:success)
                json_response = JSON.parse(response.body)
                expect(json_response["recipients"]).to be_an(Array)
                expect(json_response["recipients"].first["id"]).to eq(recipient.id)
            end
        end 

        context "with invalid event" do
            it "returns not found" do
                get :recipients, params: { event_id: 99999 }, format: :json
                expect(response).to have_http_status(:not_found)
            end
        end

        context "when gift giver is not found" do
            it "returns not found" do
                GiftGiver.destroy_all
                get :recipients, params: { event_id: event.id }, format: :json
                expect(response).to have_http_status(:not_found)

            end
        end
    end

    describe "POST #generate" do
        context "with valid parameters" do
            before do
                gift_giver  # Ensure gift_giver is created
            end
            
            it "calls the AI service with recipient preferences" do
                ai_service = double("AIService")
                allow(AIService).to receive(:new).and_return(ai_service)
                allow(ai_service).to receive(:generate_gift_ideas).and_return(["Gift 1", "Gift 2"])

                post :generate, params: { event_id: event.id, recipient_id: recipient.id }, format: :json
                expect(response).to have_http_status(:success)
                json_response = JSON.parse(response.body)
                expect(json_response["gift_ideas"]).to be_an(Array)
                expect(json_response["gift_ideas"].length).to eq(2)
            end

            it "returns recipient information" do
                ai_service = double("AIService")
                allow(AIService).to receive(:new).and_return(ai_service)
                allow(ai_service).to receive(:generate_gift_ideas).and_return(["Gift 1"])
        
                post :generate, params: { event_id: event.id, recipient_id: recipient.id }, format: :json
                json_response = JSON.parse(response.body)
                expect(json_response["recipient"]["id"]).to eq(recipient.id)
                expect(json_response["recipient"]["username"]).to eq(recipient.username)
            end
        end

        context "with invalid recipient" do
            it "returns 404" do
                post :generate, params: { event_id: event.id, recipient_id: 99999 }, format: :json
                expect(response).to have_http_status(:not_found)
            end
        end
  
        context "when recipient is not in event" do
            before do
                gift_giver  # Ensure gift_giver exists
            end
            
            it "returns forbidden" do
                other_recipient = User.create!(email: "other@test.com", username: "other", password: "password123")
                post :generate, params: { event_id: event.id, recipient_id: other_recipient.id }, format: :json
                expect(response).to have_http_status(:forbidden)
            end
        end
    end
end