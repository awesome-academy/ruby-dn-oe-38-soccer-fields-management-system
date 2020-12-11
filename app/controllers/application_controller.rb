class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :set_search

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      flash[:danger] = t "message.cancancan.not_permission"
      redirect_to root_path
    else
      flash[:danger] = t "message.cancancan.not_login"
      redirect_to login_path
    end
  end

  private

  def default_url_options
    {locale: I18n.locale}
  end

  def set_search
    @q = Location.ransack(params[:q])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_search_location
    return unless params[:q]

    return if @q.result.present?

    flash[:warning] = t "search.danger"
  end
end
