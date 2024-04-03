class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_csrf_cookie
  
  include ActionController::Cookies
	include ActionController::RequestForgeryProtection
  #https://medium.com/@austinrhoads/session-store-with-react-rails-api-116a9efe3c30
  
  private 

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :role_id])
  end

  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = {
      value: form_authenticity_token,
      domain: :all 
    }
  end

end