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

      @scripture = @scripture.attributes.merge({
        scripture_type: @scripture.scripture_type.name,
        author: @scripture.author.name
      })
      @articles = @articles.map do | article |
        article.attributes.merge({
          author: article.author.name,
          article_type: article.article_type.name
        })
      end
    elsif @scripture.present? && @scripture.scripture_type.name == "कथायें"
      @articles = @scripture.stories.order("index")
      
      @scripture = @scripture.attributes.merge({
        scripture_type: @scripture.scripture_type ? @scripture.scripture_type.name : 'NA',
        author: @scripture.author ? @scripture.author.name : 'NA',
      })
    elsif @scripture.present? && @scripture.scripture_type.name == "नवीन संकलन" and @scripture.scripture_type.name == "प्रचलित संकलन"
      @articles = @scripture.cs_articles.joins(:article)

      @articles = @articles && @articles.map do | a |
        article = a.article
        article.attributes.merge({
          author: article.author.name,
          article_type: article.article_type.name
        })
      end
    end

    render json: {
      scripture: @scripture,
      articles: @articles
    }
  end

  def get_cs_articles
    @scripture = Scripture.where(name_eng: params[:id].strip).first rescue nil
    @chapters = @scripture.chapters.left_joins(:articles).order("chapters.index ASC")
    @chapters = @chapters.uniq
    @chapters = @chapters.map{ |chapter | chapter.attributes.merge({articles: chapter.articles}) }
    
    render json: {
      scripture: @scripture,
      chapters: @chapters,
    }
  end

end
