class ApplicationController < ActionController::Base
  include SessionHelper
  protect_from_forgery with: :exception

  # before_action :authenticate_user!, except: [:home]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def check_if_user_is_admin
    return true if current_user && current_user.admin?

    flash[:notice] = "Don't even.."
    redirect_to '/'
  end
end
