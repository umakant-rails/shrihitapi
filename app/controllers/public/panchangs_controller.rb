class Public::PanchangsController < ApplicationController

	def index
		get_panchangs
		render json: {
    	panchangs: @panchangs,
    	total_panchangs: @total_panchangs
    }
	end

	def show
  	render json: {panchang: @panchang}
  end

  def navigate_month
  	date = Date.parse(params[:date])
		@panchang = Panchang.where(current_panchang: true).first rescue nil
		tithis = get_tithis(date)

		render json: {
			panchang: @panchang,
			tithis: tithis,
		}
	end

  private 

  def get_panchangs
  	page = params[:page].present? ? params[:page] : 1
    @panchangs = Panchang.order("created_at DESC").page(page).per(10)
    @total_panchangs = Panchang.count
  end

  def get_tithis(date)
		start_of_month, end_of_month = date.beginning_of_month, date.end_of_month
		@tithis=PanchangTithi.where("date between ? and ?", start_of_month, end_of_month).order("date ASC") rescue []
	end

end
