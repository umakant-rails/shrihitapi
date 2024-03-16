class Admin::TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page].present? ? params[:page] : 1

    get_tags_with_params(page)
    render json: {
      tags: @tags,
      total_tags: @total_tags,
      current_page: page,
    }
  end

  def tag_approved
    page = params[:page].present? ? params[:page] : 1
    @tag = Tag.find(params[:id])

    if @tag.update(is_approved: true)
      get_tags_with_params(page)
      render json: {
        tags: @tags,
        total_tags: @total_tags,
        current_page: page,
      }
    else
      render json: { error: @tag.errors.full_messages }
    end
  end

  def destroy
    page = params[:page].present? ? params[:page] : 1
    @tag = Tag.find(params[:id])

    if @tag.destroy
      get_tags_with_params(page)
      render json: { 
        total_tags: @total_tags,
        tags: @tags,
        current_page: page,
      }
    else
      render json: { error: @tag.errors.full_messages }
    end
  end

  private 
    def get_tags_with_params(page)      
      arr = []

      arr.push('is_approved=true') if params[:status].present? && params[:status] == "approved"
      arr.push('(is_approved is null or is_approved=false)') if params[:status].present? && params[:status] == "pending"
      arr.push("name like '#{params[:start_with]}%'") if params[:start_with].present?

      if arr.present?
        queryy = arr.join(' and ')
        @total_tags = Tag.where(queryy).count
        @tags = Tag.where(queryy).page(page).per(10)
      else
        @total_tags = Tag.count
        @tags = Tag.order("created_at DESC").page(page).per(10)
      end
    end
end
