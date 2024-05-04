class CurrentUserController < ApplicationController
  # before_action :authenticate_user!

  def index
    if current_user
      render json: {current_user: current_user, status: :ok}
    else 
      render json: {current_user: nil, status: :ok}
    end
  end

  def get_user_role
    if current_user
      render json: {role: current_user.role_id}
    else 
      render json: {role: nil, status: :ok}
    end
  end

end
