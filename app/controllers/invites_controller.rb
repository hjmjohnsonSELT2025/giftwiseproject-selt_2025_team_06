class InvitesController < ApplicationController
  before_action :require_login

  def index
    @invites = current_user.invites.where(status: "pending").includes(:event)
  end

  def accept
    invite = current_user.invites.find(params[:id])
    invite.update!(status: "accepted")
    GiftGiver.create!(event_id: invite.event_id, user_id: current_user.id)

    flash[:notice] = "Invitation to event accepted"
    redirect_to events_path
  end
end