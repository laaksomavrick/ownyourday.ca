# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # rubocop:disable Lint/UselessMethodDefinition
    # GET /resource/sign_up
    def new
      super
    end

    # POST /resource
    def create
      email = params[:user][:email]

      if FeatureFlags.users_registration_allow_list_enabled? == false
        super
        return
      end

      email_in_allow_list = UserAllowList.email_in_allow_list?(email)

      if email_in_allow_list == false
        flash[:alert] = t('.disabled')
        redirect_to new_user_registration_path
        return
      end

      super
    end
    # rubocop:enable Lint/UselessMethodDefinition

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:time_zone, :first_name, :last_name])
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
