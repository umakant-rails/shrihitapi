class Admin::PanchangTithisController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_panchang

	def new 
		date = @tithi.present? ? @tithi.date : Date.today
		get_current_month
		get_tithis(date)
		render json: {
			panchang: @panchang,
			tithis: @tithis,
			current_month: @current_month
		}
	end

	def create
    @tithi = @panchang.panchang_tithis.new(panchang_tithi_params)
    is_exist = @panchang.panchang_tithis.where(panchang_tithi_params).present?
    tithis_by_dt = PanchangTithi.where(date:  params[:panchang_tithi][:date])
    last_tithi = PanchangTithi.order("date ASC").last

    if is_exist
    	render json: { error: ["This tithi is already saved with same date."]}
    elsif tithis_by_dt.length > 1
    	render json: { error: ["There are two tithis add with this date #{ params[:panchang_tithi][:date]}"]}
    elsif Date.parse(params[:panchang_tithi][:date]).mjd - last_tithi.date.mjd > 1
    	render json: { error: ["The entry should be entered at date #{last_tithi.date.next_day.strftime("%d/%m/%Y")}."]}
    elsif last_tithi.paksh == params[:panchang_tithi][:paksh] && params[:panchang_tithi][:tithi] - last_tithi.tithi > 1
    	render json: { error: ["The last entered tithi is #{last_tithi.paksh} #{last_tithi.tithi}, you should entered next successive tithi."]}
   	elsif (last_tithi.paksh != params[:panchang_tithi][:paksh] && 
   			last_tithi.tithi - params[:panchang_tithi][:tithi] != 14 )
    	render json: { error: ["The last entered tithi is #{last_tithi.paksh} #{last_tithi.tithi}, you should entered next successive tithi."]}
   	else
	    if @tithi.save
	    	get_tithis(Date.parse( params[:panchang_tithi][:date]))
	    	get_current_month
	    	render json: {
	    		tithi: @tithi, tithis: @tithis, current_month: @current_month,
	    		notice: 'Tithi is created successfully.'
	    	}
	    else
	    	render json: {tithi: @tithi.errors.full_messages, notice: @tithi.errors.full_messages}
	    end	
	  end
	end

	def navigate_month
		get_current_month
		get_tithis(Date.parse(params[:date]))
		render json: {
			panchang: @panchang,
			tithis: @tithis,
			current_month: @current_month
		}
	end

	private
	
	def get_current_month
		@panchang.hindi_months.each do | month |
			tithi = month.panchang_tithis.last rescue nil

			if !tithi
				@current_month = month
				break;
			end

			if not(tithi.tithi == 15 && tithi.paksh == "शुक्ळ पक्ष")
				@current_month = tithi.hindi_month
				break;
			end
		end
	end

	def get_tithis(date)
		start_of_month, end_of_month = date.beginning_of_month, date.end_of_month
		@tithis=PanchangTithi.where("date between ? and ?", start_of_month, end_of_month) rescue []
	end

	def set_panchang
    @panchang = Panchang.find(params[:panchang_id])
  end

  def verify_admin
    if !current_user.is_admin && !current_user.is_super_admin
      redirect_to new_user_session_path
    end
  end

  def panchang_tithi_params
		params.fetch(:panchang_tithi, {}).permit(:date, :tithi, :paksh, :description, :title, :year,
			:panchang_id,	:hindi_month_id, :coupled_with_dates)
	end

  def set_panchang_tithi
    @panchang_tithi = PanchangTithi.find(params[:id])
  end

end
