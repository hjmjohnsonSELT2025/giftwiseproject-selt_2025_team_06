require_relative '../../../app/services/ai_service'

module Events
  class GiftIdeasController < ApplicationController
    before_action :set_event
    before_action :require_login

    def recipients
      recipients = @event.recipients.includes(:user).map do |recipient|
        {
          id: recipient.user.id,
          username: recipient.user.username,
          email: recipient.user.email
        }
      end

      render json: { recipients: recipients }
    end

    def generate
      recipient_id = params[:recipient_id]
      recipient = User.find_by(id: recipient_id)

      if recipient.nil?
        render json: { error: "Recipient not found" }, status: :not_found
        return
      end

      recipient_record = @event.recipients.find_by(user_id: recipient_id)
      
      if recipient_record.nil?
        render json: { error: "Recipient not associated with this event" }, status: :forbidden
        return
      end

      ai_service = ::AIService.new
      gift_ideas = ai_service.generate_gift_ideas(recipient, @event)

      render json: {
        recipient: {
          id: recipient.id,
          username: recipient.username,
          likes: JSON.parse(recipient.likes || '[]'),
          dislikes: JSON.parse(recipient.dislikes || '[]')
        },
        gift_ideas: gift_ideas
      }
    end

    private

    def set_event
        @event = Event.find(params[:event_id] || params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Event not found" }, status: :not_found
      end
    end
  end