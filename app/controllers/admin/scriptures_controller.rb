class Admin::ScripturesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_scripture, only: %i[ show edit update destroy ]

  # GET /admin/scriptures or /admin/scriptures.json
  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:scripture_type_id].present?
      @scriptures = Scripture.where("scripture_type_id = ?", params[:scripture_type_id])
      @total_scriptures = Scripture.where("scripture_type_id = ?", params[:scripture_type_id]).count
      
    else
      @scriptures = Scripture.all
      @total_scriptures = Scripture.count
    end
    @scripture_types = ScriptureType.order("name ASC")

    scripture_tmp = @scriptures.map do |scripture|
      scripture.attributes.merge({
        scripture_type: scripture.scripture_type.name,
        author: scripture.author ? scripture.author.name : '-'
      })
    end

    render json: {
      scriptures: scripture_tmp,
      total_scriptures: @total_scriptures,
      scripture_types: @scripture_types,
      current_page: page
    }
  end

  # GET /admin/scriptures/1 or /admin/scriptures/1.json
  def show
    @sections = @scripture.sections
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
    # params[:scripture][:has_chapter] = params[:scripture][:has_chapter] == 'Yes' ? true : false
    @scripture_types = ScriptureType.all
    @scripture = current_user.scriptures.new(scripture_params)

    respond_to do |format|
      if @scripture.save
        # format.html { redirect_to admin_scripture_url(@scripture), notice: "Scripture was successfully created." }
        format.html { redirect_to admin_scripture_url(@scripture), notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक बनाया गया।" }
        format.json { render :show, status: :created, location: @scripture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scripture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/scriptures/1 or /admin/scriptures/1.json
  def update
    
    # params[:scripture][:has_chapter] = params[:scripture][:has_chapter] == 'Yes' ? true : false

    respond_to do |format|
      if @scripture.update(scripture_params)
        format.html { redirect_to admin_scripture_url(@scripture), notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक अद्यतित किया गया।" }
        format.json { render :show, status: :ok, location: @scripture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scripture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/scriptures/1 or /admin/scriptures/1.json
  def destroy
    @scripture.destroy

    respond_to do |format|
      format.html { redirect_to admin_scriptures_url, notice: "रसिक वाणी/ग्रन्थ सफलतापूर्वक डिलीट किया गया।" }
      format.json { head :no_content }
    end
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

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end

end
