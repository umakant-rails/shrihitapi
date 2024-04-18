class Admin::PanchangsController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_panchang, only: %i[ show edit update destroy ]

	def index
		get_panchangs
		render json: {
    	panchangs: @panchangs,
    	total_panchangs: @total_panchangs
    }
	end

	def create
		month_order = 0
  	@panchang = Panchang.new(panchang_params)
  	if @panchang.save
    	HindiMonth::MONTH.each do | month |
				month_order = month_order + 1
				@panchang.hindi_months.create({name: month, order: month_order, is_purshottam_month: false})
				if month == params[:purshottam_month]
					month_order = month_order + 1
					@panchang.hindi_months.create({name: "#{month}", order: month_order, is_purshottam_month: true})
				end
			end
    	render json: {panchang: @panchang, notice: "पंचांग की एंट्री सफलतापूर्वक की गई."}
    else
    	render json: {panchang: @panchang.errors.full_messages, error: @panchang.errors.full_messages}
    end
  end

  def show
  	render json: {panchang: @panchang}
  end

  def update
    new_purshottam_month = params[:purshottam_month]
    if @panchang.update(panchang_params)
    	get_panchangs
    	render json: {
	    	panchangs: @panchangs,
	    	total_panchangs: @total_panchangs,
	    	notice: 'Panchang is updated successfully.'
	    }
    else
    	render json: {panchang: @panchang.errors.full_messages, error: @panchang.errors.full_messages}
    end

  end

  def destroy
  	@panchang.destroy
  	get_panchangs
  	render json: {
    	panchangs: @panchangs,
    	total_panchangs: @total_panchangs,
    	notice: 'Panchang is deleted successfully.'
    }
  end

  private

  def get_panchangs
  	page = params[:page].present? ? params[:page] : 1
    @panchangs = Panchang.order("created_at DESC").page(page).per(10)
    @total_panchangs = Panchang.count
  end

	def panchang_params
    params.fetch(:panchang, {}).permit(:title, :vikram_samvat, :panchang_type, :has_purshottam_month, :purshottam_month, :description)
  end

  def set_panchang
    @panchang = Panchang.find(params[:id])
  end

	def verify_admin
    if !current_user.is_admin && !current_user.is_super_admin
      redirect_to new_user_session_path
    end
  end

end
