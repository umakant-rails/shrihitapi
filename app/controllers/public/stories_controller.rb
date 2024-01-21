class Public::StoriesController < ApplicationController

  def index
    @stories = Story.all
    render json: {
      stories: @stories
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
