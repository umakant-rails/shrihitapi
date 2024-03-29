class Public::ScripturesController < ApplicationController

  def index
    @scriptures = Scripture.all

    scriptures_tmp = @scriptures.map do | scripture |
      scripture.attributes.merge({
        scripture_type: scripture.scripture_type.name,
        author: scripture.author ? scripture.author.name : 'NA'
      })
    end

    render json: {
      scriptures: scriptures_tmp
    }
  end

  def show
    scripture_tmp = {}

    @scripture = Scripture.where(name_eng: params[:id].strip).first rescue nil
    if @scripture.present? && @scripture.scripture_type.name == "रसिक वाणी"
      @articles = @scripture.articles.order("index")

      scriptures_tmp = @scripture.attributes.merge({
        scripture_type: @scripture.scripture_type.name,
        author: @scripture.author.name,
        articles: @articles.map do | article |
          article.attributes.merge({
            author: article.author.name,
            article_type: article.article_type.name
          })
        end
      })
    elsif @scripture.present? && @scripture.scripture_type.name == "कथायें"
      @articles = @scripture.stories.order("index")
      
      scriptures_tmp = @scripture.attributes.merge({
        scripture_type: @scripture.scripture_type ? @scripture.scripture_type.name : 'NA',
        author: @scripture.author ? @scripture.author.name : 'NA',
        articles: @articles
      })
    end

    render json: {
      scripture: scriptures_tmp
    }
  end

end
