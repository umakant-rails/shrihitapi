class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /tags or /tags.json
  def index
    # if current_user.is_admin || current_user.is_super_admin
    #   @tags = Tag.order("created_at DESC").page(params[:page])
    # else
      @tags = current_user.tags.order("created_at DESC").page(params[:page])
    # end
  end

  # GET /tags/1 or /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags or /tags.json
  def create
    params[:tag][:name] = params[:tag][:name].strip
    @tag = current_user.tags.new(tag_params)

    respond_to do |format|
      if true #@tag.save
        format.json { render :show, status: :created, location: @tag }
      else
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1 or /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_url, notice: "Tag was successfully updated." }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1 or /tags/1.json
  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url, notice: "Tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = current_user.tags.find(params[:id]) rescue nil
      if @tag.blank?
        redirect_back_or_to homes_path
      end
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.fetch(:tag, {}).permit(:name)
    end
end
