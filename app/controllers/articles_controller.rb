class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[ show edit update destroy ]

  def index
    page = params[:page].present? ? params[:page] : 1
    total_articles = current_user.articles.count
    articles = current_user.articles.order("created_at DESC").page(page).per(10)
    
    get_article_data

    articles_tmp = articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    
    render json: {
      contexts: @contexts,
      raags: @raags,
      authors: @authors,
      article_types: @article_types,
      total_articles: total_articles,
      articles: articles_tmp
    }
  end

  def new
    get_article_data
    # article = Article.new({author_id: author.id, context_id: context.id})
    
    render json: {
      tags: @tags,
      contexts: @contexts,
      raags: @raags,
      authors: @authors,
      article_types: @article_types,
      scriptures: @scriptures,
      # article: article
    }
  end

  # POST /articles or /articles.json
  def create
    params[:article][:is_approved] = (current_user.role_id == 1) ? true : false
    @article = current_user.articles.new(article_params)

    if @article.save
      create_tags_for_articles
      render json: { article: @article, notice: "Article was created successfully."}
    else
      render json: { article: @article.errors, error: @article.errors.full_messages }
    end
  end

  def show

    if params[:action_type] == "edit"
      get_article_data
      render json: {
        tags: @tags,
        contexts: @contexts,
        raags: @raags,
        authors: @authors,
        article_types: @article_types,
        scriptures: @scriptures,
        article: article_tmp
      }
    else
      comments_tmp = @article.get_comments

      article_tmp = @article.attributes.merge({
        author: @article.author.name, 
        article_type: @article.article_type.name,
        comments: comments_tmp,
        tags: @article.tags
      })

      render json: {
        article: article_tmp
      }
    end
  end

  # PUT/PATCH /articles or /articles.json
  def update
    if @article.update(article_params)
      update_tags_for_articles
      render json: { article: @article, notice: "रचना को सफलतापूर्वक अद्यतित कर दिया गया है."}
    else
      render json: { article: @article.errors, error: @article.errors.full_messages }
    end
  end

  # PUT/PATCH /articles or /articles.json
  def destroy
    if @article.destroy
      page = params[:page].present? ? params[:page] : 1
      total_articles = current_user.articles.count
      articles = current_user.articles.order("created_at DESC").page(page).per(10)
      
      render json: { 
        total_articles: total_articles,
        articles: articles,
        article: @article,
        notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया है."
      }
    else
      render json: { error: @article.errors.full_messages }
    end
  end

  def articles_by_page
    page = params[:page].present? ? params[:page] : 1
    # total_articles = Article.count
    # articles = Article.order("created_at DESC").page(page).per(10)
    arr = []

    arr.push('article_type_id='+params[:article_type_id]) if params[:article_type_id].present?
    arr.push('author_id='+params[:author_id]) if params[:author_id].present?
    arr.push('context_id='+params[:context_id]) if params[:context_id].present?
    arr.push('scripture_id='+params[:scripture_id]) if params[:scripture_id].present?
    arr.push('raag_id='+params[:raag_id]) if params[:raag_id].present?
    arr.push("(hindi_title like '%#{params[:term]}%' or content like '%#{params[:term]}%')") if params[:term].present?

    queryy = arr.join(' and ')
    if arr.length > 0
      total_articles = current_user.articles.where(queryy).count
      articles = current_user.articles.where(queryy).order("created_at DESC").page(page).per(10)
    else
      total_articles = current_user.articles.count
      articles = current_user.articles.order("created_at DESC").page(page).per(10)
    end

    articles_tmp = articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: { 
      total_articles: total_articles,
      articles: articles_tmp,
    }
  end

  private

    def article_params
      params.fetch(:article, {}).permit(:content, :raag_id, :scripture_id, :index, 
        :author_id, :article_type_id, :theme_id, :context_id, :hindi_title, 
        :english_title, :is_approved, image_attributes:[:image])
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def get_article_data
      @tags = Tag.approved.order("name ASC")
      @authors = Author.order("name ASC")
      @contexts = Context.order("name ASC")
      @raags = Raag.order("name ASC")
      @article_types = ArticleType.order("name ASC")
      @scriptures = Scripture.where("scripture_type_id in (?)", [2]).order("name ASC")
    end

    def create_tags_for_articles
      param_tags = params[:article][:tags]
      param_tags.each do | tag |
        current_user.article_tags.create(article_id: @article.id, tag_id: tag)
      end
    end

    def update_tags_for_articles
      param_tags = params[:article][:tags]

      new_tags_id = param_tags - @article.tags.pluck(:id)
      old_tags_to_remove = @article.tags.pluck(:id) - param_tags

      new_tags_id.each do | tag_id |
        current_user.article_tags.create(article_id: @article.id, tag_id: tag_id)
      end
      @article.article_tags.where("tag_id in (?)", old_tags_to_remove).destroy_all if old_tags_to_remove.present?
    end

end
