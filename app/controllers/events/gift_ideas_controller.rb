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

      likes = recipient.user_preferences.where(category: "like").includes(:preference).map { |up| up.preference.name }
      dislikes = recipient.user_preferences.where(category: "dislike").includes(:preference).map { |up| up.preference.name }

      begin
        ai_service = ::AIService.new
        gift_ideas = ai_service.generate_gift_ideas(recipient, @event, likes: likes, dislikes: dislikes)

        render json: {
          recipient: {
            id: recipient.id,
            username: recipient.username,
            likes: likes,
            dislikes: dislikes
          },
          gift_ideas: gift_ideas
        }
      rescue => e
        Rails.logger.error "Error generating gift ideas: #{e.message}\n#{e.backtrace.join("\n")}"
        render json: { 
          error: "Failed to generate gift ideas: #{e.message}",
          recipient: {
            id: recipient.id,
            username: recipient.username,
            likes: likes,
            dislikes: dislikes
          }
        }, status: :internal_server_error
      end
    end

    def chat
      recipient_id = params[:recipient_id]
      user_message = params[:message]
      conversation_history = params[:conversation_history] || []
      
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
      
      if user_message.blank?
        render json: { error: "Message cannot be blank" }, status: :bad_request
        return
      end
      
      begin
        ai_service = ::AIService.new
        response = ai_service.chat(user_message, conversation_history, recipient, @event)
        
        render json: { response: response }
      rescue => e
        Rails.logger.error "Error in chat: #{e.message}\n#{e.backtrace.join("\n")}"
        render json: { error: "Failed to get response: #{e.message}" }, status: :internal_server_error
      end
    end

    private

    def set_event
      @event = Event.find(params[:event_id] || params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Event not found" }, status: :not_found
    end
  end
end