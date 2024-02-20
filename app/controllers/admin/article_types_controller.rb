class Admin::ArticleTypesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_article_type, only: %i[ show edit update destroy ]

  # GET /article_types or /article_types.json
  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:start_with].present?
      @types = ArticleType.where("name like '#{params[:start_with]}%'").page(page).per(10)
      @total_types = ArticleType.where("name like '#{params[:start_with]}%'").count
    else
      get_type_by_page(page)
    end

    render json: {
      types: @types,
      total_types: @total_types,
      current_page: page
    }
  end

  # POST /article_types or /article_types.json
  def create
    page = params[:page].present? ? params[:page] : 1
    params[:article_type][:name] = params[:article_type][:name].strip
    @type = current_user.article_types.new(article_type_params)

    if @type.save
      get_type_by_page(page)

      render json: {
        type: @type,
        types: @types,
        total_types: @total_types,
        current_page: 1,
        status: 'Article Type is created Successfully.'
      }
    else
      render json: { type: @type.errors, error: @type.errors.full_messages }
    end
  end

  # PATCH/PUT /article_types/1 or /article_types/1.json
  def update
    page = params[:page].present? ? params[:page] : 1

    if @type.update(article_type_params)
      get_type_by_page(1)

      render json: {
        type: @type,
        types: @types,
        total_types: @total_types,
        current_page: page,
        status: 'Article Type is updated Successfully'
      }
    else
      render json: { type: @type.errors, error: @type.errors.full_messages }
    end
  end

  # DELETE /article_types/1 or /article_types/1.json
  def destroy
    @type.destroy
    page = params[:page].present? ? params[:page] : 1

    get_type_by_page(1)
    render json: { 
      type: @type,
      types: @types,
      total_types: @total_types,
      current_page: 1,
      notice: "प्रसंग को सफलतापूर्वक डिलीट कर दिया गया है."
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_type
      @type = ArticleType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_type_params
      params.fetch(:article_type, {}).permit(:name, :is_approved, :user_id)
    end

    def get_type_by_page(page)
      @total_types = ArticleType.count
      @types = ArticleType.order("created_at DESC").page(page).per(10)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
