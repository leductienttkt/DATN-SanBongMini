class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_events
  before_filter :set_cache_back

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation, :current_password
    end
  end

  private

  def load_events
    if user_signed_in?
      @events = current_user.events.by_date
      @count_unread_notification = @events.unread.size
    end
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def check_user_status_for_action
    if current_user.wait?
      flash[:danger] = t "information"
      redirect_to root_path
    end
  end

  def set_cache_back
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "#{1.year.ago}"
  end
end
