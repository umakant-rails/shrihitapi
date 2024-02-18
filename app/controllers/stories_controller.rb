class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, only: %i[show edit update destroy]

  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:start_with].present?
      @total_stories = current_user.stories.where("title like '#{params[:start_with]}%'").count
      @stories = current_user.tags.where("title like '#{params[:start_with]}%'").page(page).per(10)
    else
      @total_stories = current_user.stories.count
      @stories = current_user.stories.order("created_at DESC").page(page).per(10)
    end
    stories_tmp = @stories.map do | story | 
      story.attributes.merge({author: story.author ? story.author.name : '-'})
    end

    render json: {
      stories: stories_tmp,
      total_stories: @total_stories,
      current_page: page,
    }
  end

  def new
    @sants = Author.where(is_saint:true)
    @scripture_type = ScriptureType.where(name: "कथायें")[0]
    @scriptures = @scripture_type.scriptures rescue []
    
    render json: {
      sants: @sants,
      scriptures: @scriptures,
    }
  end

  def create
    @story = current_user.stories.new(story_params)
 
    if @story.save
      render json: { 
        story: @story, 
        notice: "Story was successfully created."
      }
    else
     render json: { story: @story.errors, error: @story.errors.full_messages }
    end
  end

  def show
    if params[:action_type] == "edit"
      @sants = Author.where(is_saint:true)
      @scripture_type = ScriptureType.where(name: "कथायें")[0]
      @scriptures = @scripture_type.scriptures rescue []
      
      render json: { 
        story: @story,
        sants: @sants,
        scriptures: @scriptures,
      }
    else
      render json: { story: @story }
    end
  end

  def update
    if @story.update(story_params)
      render json: { story: @story, notice: "संत चरित्र/प्रेरक प्रसंग को सफलतापूर्वक अद्यतित कर दिया गया है."}
    else
      render json: { story: @story.errors, error: @story.errors.full_messages }
    end
  end

  def destroy
    
    if @story.destroy
      if params[:origin_page] == "show"
        render json: { 
          story: @story,
          notice: "संत चरित्र/प्रेरक को सफलतापूर्वक डिलीट कर दिया गया है."
        }
      else
        page = params[:page].present? ? params[:page] : 1
        total_stories = current_user.stories.count
        stories = current_user.stories.order("created_at DESC").page(page).per(10)

        render json: { 
          total_stories: total_stories,
          stories: stories,
          current_page: page,
          notice: "संत चरित्र/प्रेरक को सफलतापूर्वक डिलीट कर दिया गया है."
        }
      end
    else
      render json: { error: @story.errors.full_messages }
    end
  end

  private

    def set_story
      @story = Story.find(params[:id])
    end

    def story_params
      params.fetch(:story, {}).permit(:title, :story, :index, :scripture_id, :author_id, :user_id)
    end

end
