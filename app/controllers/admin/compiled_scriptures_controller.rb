class Admin::CompiledScripturesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture
  # before_action :set_scripture, only: %i[add_articles_page add_article remove_article]

  # def index
  #   @scripture_type = ScriptureType.where(name: "प्रचलित संकलन").first
  #   @scriptures = @scripture_type.scriptures
  # end
  
  def show
    @scripture = Scripture.find(params[:id])
    @cs_articles = @scripture.cs_articles.joins(:article).order("index").page(params[:page])
  end

  def add_articles_page
    @tags = Tag.approved.order("name ASC")
    @authors = Author.order("name ASC")
    @contexts = Context.order("name ASC")
    @raags = Raag.order("name ASC")
    @article_types = ArticleType.order("name ASC")
    # @scriptures = Scripture.order("name ASC")

    get_articles_by_params

    render json: {
      contexts: @contexts,
      raags: @raags,
      authors: @authors,
      article_types: @article_types,
      scripture: @scripture,
      total_articles: @total_articles,
      articles: @articles,
      added_articles: @added_articles,
    }
  end

  def filter_articles
    get_articles_by_params

    render json: {
      total_articles: @total_articles,
      articles: @articles,
      added_articles: @added_articles
    }
  end

  def add_article
    is_article_exist = nil
    params[:cs_article][:user_id] = current_user.id
    
    if params[:cs_article][:chapter_id].present? 
      @chapter = Chapter.find(params[:cs_article][:chapter_id])
      is_article_exist = @chapter.cs_articles.where({article_id: params[:cs_article][:article_id]})
    else
      is_article_exist = @scripture.cs_articles.where({article_id: params[:cs_article][:article_id]})
    end

    @cs_article = current_user.cs_articles.new(cs_article_params)
    if @cs_article.save!
      get_articles_by_params

      render json: {
        total_articles: @total_articles,
        articles: @articles,
        added_articles: @added_articles,
        notice: "उत्सव में रचना सफलतापूर्वक जोड़ दी गई है."
      }
    else
      render json: {
        cs_article: @cs_article.errors, 
        errors: @cs_article.errors.full_messages 
      }
    end    
  end

  def remove_article
    @chapter = Chapter.find(params[:chapter_id]) rescue nil

    if @chapter.present?
      @article = @chapter.cs_articles.find(params[:cs_article_id])
    else
      @article = @scripture.cs_articles.find(params[:cs_article_id])
    end

    if @article && @article.destroy!
      get_articles_by_params

      render json: {
        total_articles: @total_articles,
        articles: @articles,
        added_articles: @added_articles,
        notice: "उत्सव से रचना सफलतापूर्वक हटा दी गई है."
      }
    end
  end

  private

    def get_articles_by_params
      param_arr = []
      added_articles_tmp, articles_tmp = []
      page = params[:page].present? ? params[:page] : 1
      
      if params[:chapter_id].present?
        @added_articles = Chapter.find(params[:chapter_id]).articles rescue nil
      else
        @added_articles = @scripture.articles rescue nil
      end

      param_arr.push("article_type_id = #{params[:article_type_id]}") if params[:article_type_id].present?
      param_arr.push("author_id = #{params[:author_id]}") if params[:author_id].present?
      param_arr.push("raag_id = #{params[:raag_id]}") if params[:raag_id].present?
      param_arr.push("context_id = #{params[:context_id]}") if params[:context_id].present?
      param_arr.push("hindi_title like '%#{params[:term]}%' or content like '%#{params[:term]}%'") if params[:term].present?

      queryy = param_arr.join(" and ")

      if queryy.present? and @added_articles.present?
        @articles = Article.where(queryy).where.not(id: @added_articles.pluck(:id))
          .order("hindi_title ASC").page(page).per(10)
        @total_articles = Article.where(queryy).where.not(id: @added_articles.pluck(:id)).count
      elsif queryy.present? and @added_articles.blank?
        @articles = Article.where(queryy).order("hindi_title ASC").page(page).per(10)
        @total_articles = Article.where(queryy).count
      elsif queryy.blank? and @added_articles.present?
        @articles = Article.where.not(id: @added_articles.pluck(:id))
          .order("hindi_title ASC").page(page).per(10)
        @total_articles = Article.where.not(id: @added_articles.pluck(:id)).count
      else
        @articles = Article.all.page(page).per(10)
        @total_articles = Article.count
      end

      @articles = @articles.map do | article |
        article.attributes.merge({article_type: article.article_type.name})
      end
      @added_articles = @added_articles.map do | article |
        article.attributes.merge({
          article_type: article.article_type.name,
          cs_article_id: article.cs_article.id
        })
      end

      # @added_articles = Kaminari.paginate_array(added_articles_tmp).page(params[:page])
      # added_articles_tmp = added_articles_tmp.blank? ? [] : added_articles_tmp.pluck(:article_id)
    
      # if params[:search_type] == 'by_attribute'
      #   queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
      #     params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      #   )
      #  elsif params[:search_type] == 'by_id'
      #   queryy = "articles.id = #{params[:article_id]}"
      # elsif params[:search_type] == 'by_term'
      #   search_term = params[:term].strip
      #   if params[:search_in] == "english"
      #     queryy = "LOWER(english_title) like '%#{search_term.downcase}%'"
      #   else
      #      queryy = "content like '%#{search_term}%'  or hindi_title like '%#{search_term}%'"
      #   end
      # end

      # articles_tmp = Article.where(queryy).where.not(id: added_articles_tmp).order("hindi_title ASC")

      # @articles = Kaminari.paginate_array(articles_tmp).page(params[:page])
    end

    def set_scripture
      @scripture = Scripture.find(params[:compiled_scripture_id])
    end

    def cs_article_params
      params.fetch(:cs_article, {}).permit(:chapter_id, :scripture_id, :article_id, :user_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end

