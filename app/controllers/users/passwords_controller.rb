# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  before_action :authenticate_user!
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    @password_action = 'create'
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    if  resource_params[:reset_password_token].present?
      @password_action = 'update_by_token'
      super
    else
      @password_action = 'update_without_token'
      if !current_user.compare_current_passowrd(params[:user][:current_password])
        render json: {error: ['Your current password is wrong.'], password_changed: false}
      elsif (params[:user][:password] == params[:user][:password_confirmation])
        current_user.change_password!(params[:user][:password])
        render json: {notice: 'Your passowrd updated successfully.', password_changed: true}
      elsif (params[:user][:password] != params[:user][:password_confirmation])
        render json: {error: ['New password and confirm password are not same.'], password_changed: false}
      else
        render json: {error: ['Something went wrong, please try again.'], password_changed: false}
      end
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  private
    def respond_with(resource, _opts = {})
      if @user.errors.full_messages.present?
        render json: { 
          action_status: false,
          error: @user.errors.full_messages 
        }
      elsif @password_action == 'update_by_token' || @password_action == 'update_without_token'
        render json: { notice: 'Your password has been updated.' }
      elsif @password_action == 'create'
        render json: {
          action_status: true,
          notice: 'You will receive an email with instructions on how to reset your password in a few minutes.'
        }
      end
    end
end
