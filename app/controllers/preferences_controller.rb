class PreferencesController < ApplicationController
  before_action :require_login

  def index
    @preferences = Preference.order(:name)
    @likes = current_user.user_preferences.where(category: "like").pluck(:preference_id)
    @dislikes = current_user.user_preferences.where(category: "dislike").pluck(:preference_id)
  end

  def bulk_save
    likes = Array(params[:likes]).reject(&:blank?).map(&:to_i)
    dislikes = Array(params[:dislikes]).reject(&:blank?).map(&:to_i)

    new_like = params[:new_like].to_s.strip.downcase
    new_dislike = params[:new_dislike].to_s.strip.downcase

    if new_like.present?
      pref = Preference.find_or_create_by!(name: new_like)
      likes << pref.id
    end

    if new_dislike.present?
      pref = Preference.find_or_create_by!(name: new_dislike)
      dislikes << pref.id
    end

    current_user.user_preferences.destroy_all

    overlap = likes & dislikes
    unless overlap.empty?
      dislikes -= overlap
    end

    likes.uniq.each do |pid|
      UserPreference.create!(
        user: current_user,
        preference_id: pid,
        category: "like"
      )
    end

    dislikes.uniq.each do |pid|
      UserPreference.create!(
        user: current_user,
        preference_id: pid,
        category: "dislike"
      )
    end

    redirect_to events_path, notice: "Preferences saved!"
  end
end