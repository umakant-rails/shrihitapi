class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_csrf_cookie
	before_action :set_public_data
  
  include ActionController::Cookies
	include ActionController::RequestForgeryProtection
  #https://medium.com/@austinrhoads/session-store-with-react-rails-api-116a9efe3c30
  
  private 

  def set_public_data
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @tags = Tag.approved.order("name ASC")
    @contributors = User.order("username ASC")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
  end

  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = {
      value: form_authenticity_token,
      domain: :all 
    }
  end

end