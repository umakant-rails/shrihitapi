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
    @story = Story.where(title: params[:id].strip)[0] rescue nil

    if @story && @story.scripture
      scripture = @story.scripture
      story_index = @story.index - 1

      @stories = scripture.stories.where("index >= ? and id not in (?)", story_index, @story.id).first(10)
      @story = @story.attributes.merge({scripture: @story.scripture})
    else
      @stories = @story.present? ? Story.where("id not in(?)", @story.id).first(10) : Story.first(10)
    end

    render json: {
      story: @story,
      stories: @stories
    }
  end

end
