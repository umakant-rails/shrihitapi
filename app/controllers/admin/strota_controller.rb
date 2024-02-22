class Admin::StrotaController < ApplicationController
  before_action :authenticate_user!
  #before_action :verify_admin
  before_action :set_strotum, only: %i[ show edit update destroy ]

  # GET /strota or /strota.json
  def index
    page = params[:page].present? ? params[:page] : 1
    strota_types = StrotaType.order("name ASC");

    if params[:strota_type_id].present?
      strota_tmp = Strotum.where("strota_type_id=?", params[:strota_type_id]).page(page).per(10)
      @total_strota = Strotum.where("strota_type_id=?", params[:strota_type_id]).count

      @strota = strota_tmp.map do |st|
        st.attributes.merge({strota_type: st.strota_type.name})
      end
    else
      get_strota_by_page(page)
    end

    render json: {
      strota: @strota,
      total_strota: @total_strota,
      strota_types: strota_types,
      current_page: page
    }
  end

  # GET /strota/1 or /strota/1.json
  def show
    if params[:action_type] == "edit"
      @strota_types = StrotaType.all
      
      render json: { 
        strotum: @strotum,
        strota_types: @strota_types,
      }
    else
      @strotum_articles = @strotum.strota_articles.order("index ASC")
      @article_types = ArticleType.order("name ASC")
      render json: { 
        strotum: @strotum,
        strotum_articles: @strotum_articles,
        article_types: @article_types
      }
    end
  end

  # GET /strota/new
  def new
    @strota_types = StrotaType.all
    
    render json: {
      strota_types: @strota_types
    }
  end

  # GET /strota/1/edit
  def edit
    @strota_types = StrotaType.all

    render json: {
      strotum: @strotum,
      strota_types: @strota_types
    }
  end

  # POST /strota or /strota.json
  def create
    @strotum = Strotum.new(strotum_params)

    
    if @strotum.save
      render json: { 
        strotum: @strotum, 
        notice: "Strotum was successfully created." 
      }
    else
      render json: { 
        strotum: @strotum.errors,
        error: @strotum.errors.full_messages
      }
    end
  end

  # PATCH/PUT /strota/1 or /strota/1.json
  def update
    if @strotum.update(strotum_params)
      render json: { 
        strotum: @strotum, 
        notice: "Strotum was successfully updated." 
      }
    else
      render json: { 
        strotum: @strotum.errors,
        error: @strotum.errors.full_messages
      }
    end
  end

  # DELETE /strota/1 or /strota/1.json
  def destroy
    page = params[:page].present? ? params[:page] : 1
    @strotum.destroy
    
    get_strota_by_page(page)

    render json: { 
      strotum: @strotum,
      strota: @strota,
      total_strota: @total_strota,
      current_page: page,
      notice: "Strotum was successfully deleted." 
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strotum
      @strotum = Strotum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strotum_params
      params.require(:strotum).permit(:title, :source, :strota_type_id, :keyword)
    end

    def get_strota_by_page(page)
      strota_tmp = Strotum.order("created_at DESC").page(page).per(10)
      @total_strota = Strotum.count

      @strota = strota_tmp.map do |st|
        st.attributes.merge({strota_type: st.strota_type.name})
      end
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end
end
