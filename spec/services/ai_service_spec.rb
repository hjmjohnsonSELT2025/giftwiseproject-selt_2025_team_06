require 'rails_helper'
require_relative '../../app/services/ai_service'

RSpec.describe AIService do
  let(:recipient) do
    User.create!(
      email: "test@test.com",
      username: "testuser",
      password: "password123",
      likes: '["books", "coffee", "art"]',
      dislikes: '["chocolate", "loud music"]'
    )
  end

  let(:event) do
    Event.create!(
      title: "Test Event",
      event_date: Date.today + 30,
      location: "Test Location",
      budget: 100.00,
      theme: "Birthday",
      user_id: 1
    )
  end

  describe "#generate_gift_ideas" do
    it "generates gift ideas based on recipient preferences" do
      service = AIService.new
      result = service.generate_gift_ideas(recipient, event)
      
      expect(result).to be_an(Array)
      expect(result.length).to be > 0
    end

    it "works without an event" do
      service = AIService.new
      result = service.generate_gift_ideas(recipient)
      
      expect(result).to be_an(Array)
      expect(result.length).to be > 0
    end

    it "includes recipient likes in the prompt" do
      service = AIService.new
      allow(service).to receive(:call_openai_api).and_return({
        'choices' => [{ 'message' => { 'content' => 'Test gift ideas' } }]
      })
      
      service.generate_gift_ideas(recipient)
      
      expect(service).to have_received(:call_openai_api)
    end

    it "includes recipient dislikes in the prompt" do
      service = AIService.new
      allow(service).to receive(:call_openai_api).and_return({
        'choices' => [{ 'message' => { 'content' => 'Test gift ideas' } }]
      })
      
      service.generate_gift_ideas(recipient)
      
      expect(service).to have_received(:call_openai_api)
    end

    it "handles API errors gracefully" do
      service = AIService.new
      allow(service).to receive(:call_openai_api).and_raise(StandardError.new("API Error"))
      
      expect {
        service.generate_gift_ideas(recipient)
      }.to raise_error(StandardError, "API Error")
    end

    it "parses gift ideas from API response correctly" do
      service = AIService.new
      mock_response = {
        'choices' => [{
          'message' => {
            'content' => "• Gift 1\n• Gift 2\n• Gift 3"
          }
        }]
      }
      allow(service).to receive(:call_openai_api).and_return(mock_response)
      
      result = service.generate_gift_ideas(recipient)
      
      expect(result.length).to eq(3)
      expect(result.first).to eq("Gift 1")
    end
  end
end