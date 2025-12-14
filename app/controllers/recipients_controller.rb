class RecipientsController < ApplicationController
  before_action :require_login

  def create
    recipient = Recipient.create!(
      event_id: params[:event_id],
      user_id: params[:user_id]
    )
    redirect_back fallback_location: events_path
  end

  def destroy
    recipient = Recipient.find(params[:id])
    recipient.destroy!
    redirect_back fallback_location: events_path
  end
end
