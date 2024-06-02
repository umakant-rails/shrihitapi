class PanchangsController < ApplicationController
	before_action :authenticate_user!

	def index
		get_panchangs
		render json: {
    	panchangs: @panchangs,
    	total_panchangs: @total_panchangs
    }
	end

	def navigate_month
    date = Date.parse(params[:date])
    @panchang = Panchang.find(params[:id])
    current_month = @panchang.get_current_month
    get_tithis(date)
    tithi = @panchang.panchang_tithis.order("date, hindi_month_id, tithi asc").last
    render json: {
      panchang: @panchang,
      tithis: @tithis,
      tithi: tithi,
      current_month: current_month
    }
  end

  private

  def get_tithis(date)
    start_of_month, end_of_month = date.beginning_of_month, date.end_of_month
    @tithis=PanchangTithi.where("date between ? and ?", start_of_month, end_of_month).order("date ASC") rescue []
  end

  def get_panchangs
  	page = params[:page].present? ? params[:page] : 1
    @panchangs = Panchang.order("created_at DESC").page(page).per(10)
    @total_panchangs = Panchang.count
  end

end
