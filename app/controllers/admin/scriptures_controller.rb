class Admin::ScripturesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture, only: %i[ show edit update destroy ]

  # GET /admin/scriptures or /admin/scriptures.json
  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:scripture_type_id].present?
      @scriptures = Scripture.where("scripture_type_id = ?", params[:scripture_type_id]).page(page).per(10)
      @total_scriptures = Scripture.where("scripture_type_id = ?", params[:scripture_type_id]).count
      @scripture_types = ScriptureType.order("name ASC")
    else
      get_scripture_by_page(page)
    end

    render json: {
      scriptures: @scriptures,
      total_scriptures: @total_scriptures,
      scripture_types: @scripture_types,
      current_page: page
    }
  end

  # GET /admin/scriptures/1 or /admin/scriptures/1.json
  def show
    if params[:action_type] == 'edit'
      @scripture_types = ScriptureType.order("name ASC")
      @authors = Author.order("name ASC")

      render json: {
        scripture_types: @scripture_types,
        authors: @authors,
        scripture: @scripture
      }
    else
      render json: {
        scripture: @scripture,
        sections: @scripture.sections,
        chapters: @scripture.chapters,
        articles: @scripture.scripture_articles.page(1).per(10),
        total_articles: @scripture.scripture_articles.count,
        current_page: 1
      }
    end
  end

  # GET /admin/scriptures/new
  def new
    @scripture_types = ScriptureType.order("name ASC")
    @authors = Author.order("name ASC")

    render json: {
      scripture_types: @scripture_types,
      authors: @authors
    }
  end

  # GET /admin/scriptures/1/edit
  def edit
    @scripture_types = ScriptureType.all
  end

  # POST /admin/scriptures or /admin/scriptures.json
  def create
    @scripture = current_user.scriptures.new(scripture_params)

    if @scripture.save
      render json: {
        scripture: @scripture,
        notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक बनाया गया।"
      } 
    else
      render json: {
        scriptures: @scripture.errors,
        error: @scripture.errors.full_messages,
        notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक बनाया गया।"
       } 
    end

  end

  # PATCH/PUT /admin/scriptures/1 or /admin/scriptures/1.json
  def update    
    if @scripture.update(scripture_params)
      render json: { 
        scripture: @scripture, 
        notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक अद्यतित किया गया।" 
      }
    else
      render json: { 
        scripture: @scripture.errors,
        error: @scripture.errors.full_messages, 
      }
    end
  end

  # DELETE /admin/scriptures/1 or /admin/scriptures/1.json
  def destroy
    @scripture.destroy
    get_scripture_by_page(1)

    render json: {
      scriptures: @scriptures,
      total_scriptures: @total_scriptures,
      scripture_types: @scripture_types,
      current_page: 1,
      notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक डिलीट किया गया।"
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scripture
      @scripture = Scripture.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scripture_params
      params.fetch(:scripture, {}).permit(:scripture_type_id, :name, :name_eng,:author_id, :description)
    end

    def get_scripture_by_page(page)
      scriptures_tmp = Scripture.all.page(page).per(10)
      @total_scriptures = Scripture.count
      @scripture_types= ScriptureType.order("name ASC")

      @scriptures = scriptures_tmp.map do |scripture|
        scripture.attributes.merge({
          scripture_type: scripture.scripture_type.name,
          author: scripture.author ? scripture.author.name : '-'
        })
      end
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end

end
