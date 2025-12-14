class Admin::PanchangTithisController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_panchang
  before_action :set_panchang_tithi , only: %i[ update destroy ]

  def new 
    tithi = PanchangTithi.order("date, hindi_month_id, tithi asc").last rescue nil
    @months = @panchang.hindi_months
    get_tithis(Date.today())
    render json: { panchang: @panchang, months: @months, panchang_tithiya: @tithis }
  end

  def create
    @tithi = @panchang.panchang_tithis.new(panchang_tithi_params);

    if @tithi.save 
      get_tithis(params[:panchang_tithi][:date].to_date)
      render json: {
        tithi: @tithi,
        panchang_tithiya: @tithis,
        notice: 'Tithi is created successfully.'
      }
    else
      render json: {tithi: @tithi.errors.full_messages, notice: @tithi.errors.full_messages}
    end 
  end

  def update
    if @panchang_tithi.update(panchang_tithi_params)
      get_tithis(params[:panchang_tithi][:date].to_date)
      render json: {
        panchang_tithiya: @tithis,
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
    render json: {
      panchang_tithiya: @tithis,
      notice: 'Tithi is deleted successfully.'
    }
  end

  def navigate_month
    date = Date.parse(params[:date])
    get_tithis(date)

    render json: {
      panchang: @panchang,
      tithis: @tithis,
      # tithi: tithi,
      current_month: current_month
    }
  end

  private

  def get_tithis(date)
    start_of_month, end_of_month = date.beginning_of_month, date.end_of_month
    # @tithis=PanchangTithi.where("date between ? and ?", start_of_month, end_of_month).order("date DESC") rescue []
    @tithis=PanchangTithi.order("date DESC") rescue []
    
    @tithis = @tithis.map do |t|
      t.attributes.merge(
        hindi_month: t.hindi_month&.name,
        is_purshottam_month: t.hindi_month&.is_purshottam_month
      )
    end
  end

  def date_diffrence(date1, date2)
    if date1 > date2
      return date1.mjd-date2.mjd
    else
      return date2.mjd-date1.mjd
    end
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
      :panchang_id, :hindi_month_id)
  end

  def set_panchang_tithi
    @panchang_tithi = PanchangTithi.find(params[:id])
  end

end
