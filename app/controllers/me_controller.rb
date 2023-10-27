# frozen_string_literal: true

class MeController < ApplicationController
  def edit; end

  def update
    params = update_user_params
    time_zone = params[:time_zone]
    first_name = params[:first_name]
    last_name = params[:last_name]
    avatar = params[:avatar]

    current_user.time_zone = time_zone
    current_user.first_name = first_name
    current_user.last_name = last_name

    current_user.avatar.attach(avatar) if avatar

    current_user.save

    if current_user.errors.empty? == false
      render 'edit', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.update_successful', name: 'user information')
    redirect_to me_path
  end

  private

  def update_user_params
    params.fetch(:user, {}).permit(
      :time_zone,
      :first_name,
      :last_name,
      :avatar
    )
  end
end
