class Admin::UserMgmtsController < ApplicationController
	before_action :authenticate_user!

	def index
		page = params[:page].present? ? params[:page] : 1
		get_users(page)
		render json: {
			users: @users,
			total_users: @total_users,
			current_page: page
		}
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		get_users(1)
		render json: {
			users: @users,
			total_users: @total_users,
			current_page: 1,
			notice: 'User has been deleted successfully.'
		}
	end

	private

		def get_users(page)
		  arr = ["role_id > 2"];
		  arr.push("username like '#{params[:start_with]}%'") if params[:start_with].present?
		  queryy = arr.join(' and ')

			if params[:order] == "ASC"
				@users = User.where(queryy).order("username ASC").page(page).per(10)
				@total_users =  User.where(queryy).count
			elsif params[:order] == "DESC"
				@users = User.where(queryy).order("username DESC").page(page).per(10)
				@total_users =  User.where(queryy).count
			else
				@users = User.where(queryy).order("created_at DESC").page(page).per(10)
				@total_users =  User.where(queryy).count
			end
		end

end
