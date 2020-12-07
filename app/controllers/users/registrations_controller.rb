# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update

  # POST /resource
  def create
    super
  end

  # PUT /resource
  def update
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    added_attrs = [:name, :phone, :email, :password,
      :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    added_attrs = [:name, :phone, :email, :password,
    :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
