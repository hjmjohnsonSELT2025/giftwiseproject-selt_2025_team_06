require_relative '../../../app/services/ai_service'

module Events
    class GiftIdeasController < ApplicationController
      before_action :set_event
      before_action :require_login
  
      def recipients
        gift_giver = @event.gift_givers.find_by(user_id: session[:user_id])
        
        if gift_giver.nil?
          render json: { error: "Gift giver not found" }, status: :not_found
          return
        end
  
        recipient_ids = JSON.parse(gift_giver.recipients || '[]')
        recipients = User.where(id: recipient_ids).map do |user|
          {
            id: user.id,
            username: user.username,
            email: user.email
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
  
    
        gift_giver = @event.gift_givers.find_by(user_id: session[:user_id])
        
        if gift_giver.nil?
          render json: { error: "Gift giver not found" }, status: :not_found
          return
        end
        
        recipient_ids = JSON.parse(gift_giver.recipients || '[]')
        
        unless recipient_ids.include?(recipient.id)
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