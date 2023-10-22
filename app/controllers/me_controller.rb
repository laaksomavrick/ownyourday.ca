# frozen_string_literal: true

class MeController < ApplicationController
  def edit
    @me = current_user
  end

  def update
    time_zone = params.fetch(:user).require('time_zone')

    current_user.time_zone = time_zone

    current_user.save

    if current_user.errors.empty? == false
      render 'edit', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.update_successful', name: 'time zone')
    redirect_to me_path
  end
end
