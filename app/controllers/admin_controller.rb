class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  private

  def check_admin
    return if current_user.admin?

    flash[:warning] = t "message.is_admin"
    redirect_to root_path
  end
end
