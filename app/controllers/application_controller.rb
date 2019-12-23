class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


  around_action :switch_locale

  def switch_locale(&action)

    if user_signed_in?
      locale = current_user.locale
    elsif params[:locale].nil? === false
      locale = params[:locale]
    else
      locale = I18n.default_locale
    end
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { host: ENV["CLASSIFEDS_DOMAIN"] || "localhost:3000" }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
