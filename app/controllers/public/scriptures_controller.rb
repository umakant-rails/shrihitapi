class Public::ScripturesController < ApplicationController

  def index
    @scriptures = Scripture.all

    scriptures_tmp = @scriptures.map do | scripture |
      scripture.attributes.merge({
        scripture_type: scripture.scripture_type.name,
        author: scripture.author.name
      })
    end

    render json: {
      scriptures: scriptures_tmp
    }
  end

  def show
    @scripture = Scripture.where(name_eng: params[:id].strip).first rescue nil
    if @scripture.present? && @scripture.scripture_type.name == "रसिक वाणी"
      @articles = @scripture.articles.order("index")
    elsif @scripture.present? && @scripture.scripture_type.name == "कथायें"
      @articles = @scripture.stories.order("index")
    end

    respond_to do |format|
      format.html {}
    end
  end

end
