class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user, status: :ok
  end

  def get_user_role
    render json: {role: current_user.role_id}
  end

end
