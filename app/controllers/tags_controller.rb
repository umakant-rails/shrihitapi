class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /tags or /tags.json
  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:start_with].present?
      @total_tags = current_user.tags.where("name like '#{params[:start_with]}%'").count
      @tags = current_user.tags.where("name like '#{params[:start_with]}%'").page(page).per(10)
    else
      @total_tags = current_user.tags.count
      @tags = current_user.tags.order("created_at DESC").page(page).per(10)
    end

    render json: {
      tags: @tags,
      total_tags: @total_tags,
      current_page: page,
    }
  end

  # GET /tags/1 or /tags/1.json
  def show
  end

  # POST /tags or /tags.json
  def create
    params[:tag][:name] = params[:tag][:name].strip
    @tag = current_user.tags.new(tag_params)

    if @tag.save
      total_tags = current_user.tags.count
      tags = current_user.tags.order("created_at DESC").page(params[:page]).per(10)

      render json: {
        tags: tags,
        total_tags: total_tags,
        tag: @tag,
        current_page: 1,
        status: 'Tag is created Successfully.'
      }
    else
      render json: { tag: @tag.errors, error: @tag.errors.full_messages }
    end
  end

  # PATCH/PUT /tags/1 or /tags/1.json
  def update
    page = params[:page].present? ? params[:page] : 1

    if @tag.update(tag_params)
      get_tags_by_page(1)

      render json: {
        tag: @tag,
        tags: @tags,
        total_tags: @total_tags,
        current_page: page,
        status: 'Tag is updated Successfully'
      }
    else
      render json: { tag: @tag.errors, error: @tag.errors.full_messages }
    end

  end

  # DELETE /tags/1 or /tags/1.json
  def destroy
    @tag.destroy
    page = params[:page].present? ? params[:page] : 1

    get_tags_by_page(1)
    render json: { 
      tag: @tag,
      tags: @tags,
      total_tags: @total_tags,
      current_page: 1,
      notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया है."
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = current_user.tags.find(params[:id]) rescue nil
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.fetch(:tag, {}).permit(:name)
    end

    def get_tags_by_page(page)
      @total_tags = current_user.tags.count
      @tags = current_user.tags.order("created_at DESC").page(page).per(10)
    end
end
