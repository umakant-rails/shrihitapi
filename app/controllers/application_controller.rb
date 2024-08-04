class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_csrf_cookie
  before_action :varify_user_for_admin_activities
  
  include ActionController::Cookies
	include ActionController::RequestForgeryProtection
  #https://medium.com/@austinrhoads/session-store-with-react-rails-api-116a9efe3c30
  
  private 

  def varify_user_for_admin_activities
    #head :unauthorized if get_current_user.nil?
    if params[:controller].index('admin/').present? and !(current_user && current_user.has_admin_accessibily)
      # head :unauthorized
      render json: { error: ['You are not authrized for this page or action.'], status: :unauthorized}
      # head :unauthorized #if get_current_user.nil?
    end
  end

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