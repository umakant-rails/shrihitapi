class Admin::PanchangTithisController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_panchang
	before_action :set_panchang_tithi , only: %i[ update destroy ]

	def new 
		tithi = PanchangTithi.order("date asc").last rescue nil
		current_month = @panchang.get_current_month;
		render json: { last_tithi: tithi, month: current_month }
	end

	def create
    @tithi = @panchang.panchang_tithis.new(panchang_tithi_params)
    is_exist = @panchang.panchang_tithis.where(panchang_tithi_params).present?
    tithis_by_dt = PanchangTithi.where(date:  params[:panchang_tithi][:date])
    last_tithi = @panchang.panchang_tithis.order("date, created_at ASC").last

    if is_exist
    	render json: { error: ["This tithi is already saved with same date."]}
    elsif tithis_by_dt.length > 1
    	render json: { error: ["There are two tithis add with this date #{ params[:panchang_tithi][:date]}"]}
    elsif last_tithi && (Date.parse(params[:panchang_tithi][:date]).mjd - last_tithi.date.mjd > 1)
    	render json: { error: ["The entry should be entered at date #{last_tithi.date.next_day.strftime("%d/%m/%Y")}."]}
    elsif last_tithi && (last_tithi.paksh == params[:panchang_tithi][:paksh]) && (params[:panchang_tithi][:tithi] - last_tithi.tithi > 1)
    	render json: { error: ["The last entered tithi is #{last_tithi.paksh} #{last_tithi.tithi}, you should entered next successive tithi."]}
   	elsif last_tithi && (last_tithi.paksh != params[:panchang_tithi][:paksh] && 
   			last_tithi.tithi - params[:panchang_tithi][:tithi] != 14 )
    	render json: { error: ["The last entered tithi is #{last_tithi.paksh} #{last_tithi.tithi}, you should entered next successive tithi."]}
   	else
	    if @tithi.save
	    	get_tithis(Date.parse( params[:panchang_tithi][:date]))
	    	current_month = @panchang.get_current_month
	    	render json: {
	    		tithi: @tithi, tithis: @tithis, current_month: current_month,
	    		notice: 'Tithi is created successfully.'
	    	}
	    else
	    	render json: {tithi: @tithi.errors.full_messages, notice: @tithi.errors.full_messages}
	    end	
	  end
	end

	def get_editing_data
		date = Date.parse(params[:date])
		get_tithis(date)
		months = @panchang.hindi_months
		render json: {
			panchang: @panchang,
			tithis: @tithis,
			months: months
		}
	end

	def update
		if @panchang_tithi.update(panchang_tithi_params)
			get_tithis(@panchang_tithi.date)
			months = @panchang.hindi_months
			render json: {
				panchang: @panchang,
				tithis: @tithis,
				months: months,
				notice: 'Tithi is updated successfully.'
			}
		else
			render json: {tithi: @tithi.errors.full_messages, notice: @tithi.errors.full_messages}
		end
	end

	def destroy
		date = @panchang_tithi.date
		@panchang_tithi.destroy
		get_tithis(date)
		months = @panchang.hindi_months
		render json: {
			panchang: @panchang,
			tithis: @tithis,
			months: months,
			notice: 'Tithi is deleted successfully.'
		}
	end

	def navigate_month
		date = Date.parse(params[:date])
		current_month = @panchang.get_current_month
		get_tithis(date)
		tithi = @panchang.panchang_tithis.order("date ASC").last
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
