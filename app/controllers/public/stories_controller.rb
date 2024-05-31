class Public::StoriesController < ApplicationController

  def index
    page = params[:page].present? ? params[:page] : 1
    @stories = Story.page(page).per(10)
    @total_stories = Story.all.count
    render json: {
      stories: @stories,
      total_stories: @total_stories
    }
  end

  def show
    @story = Story.where(title: params[:id])[0] rescue nil
    @stories = @story.present? ? Story.where("id not in(?)", @story.id).first(10) : Story.first(10)
    
    render json: {
      story: @story,
      stories: @stories
    }
  end

end
