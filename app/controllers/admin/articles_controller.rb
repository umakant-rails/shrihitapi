class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page].present? ? params[:page] : 1
    total_articles = Article.count
    articles = Article.order("created_at DESC").page(page).per(10)

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
      scriptures: @scriptures,
      articles: articles_tmp,
      current_page: page,
    }
  end

  def articles_by_page
    page = params[:page].present? ? params[:page] : 1
    get_articles_with_params(page)
    render json: { 
      total_articles: @total_articles,
      articles: @articles,
      current_page: page,
    }
  end

  def article_approved
    page = params[:page].present? ? params[:page] : 1
    @article = Article.find(params[:id])

    if @article.update(is_approved: true)
      get_articles_with_params(page)
      render json: { 
        total_articles: @total_articles,
        articles: @articles,
        current_page: page,
      }
    else
      render json: { error: @article.errors.full_messages }
    end
  end

  def destroy
    page = params[:page].present? ? params[:page] : 1
    @article = Article.find(params[:id])

    if @article.destroy
      get_articles_with_params(page)
      render json: { 
        total_articles: @total_articles,
        articles: @articles,
        current_page: page,
      }
    else
      render json: { error: @article.errors.full_messages }
    end
  end

  private
    def get_article_data
      @tags = Tag.approved.order("name ASC")
      @authors = Author.order("name ASC")
      @contexts = Context.order("name ASC")
      @raags = Raag.order("name ASC")
      @article_types = ArticleType.order("name ASC")
      @scriptures = Scripture.where("scripture_type_id in (?)", [2]).order("name ASC")
    end

    def get_articles_with_params(page)
      arr = []

      arr.push('article_type_id='+params[:article_type_id]) if params[:article_type_id].present?
      arr.push('author_id='+params[:author_id]) if params[:author_id].present?
      arr.push('context_id='+params[:context_id]) if params[:context_id].present?
      arr.push('scripture_id='+params[:scripture_id]) if params[:scripture_id].present?
      arr.push('is_approved=true') if params[:status].present? && params[:status] == "approved"
      arr.push('(is_approved is null or is_approved = false)') if params[:status].present? && params[:status] == "pending"
      arr.push("(hindi_title like '%#{params[:term]}%' or content like '%#{params[:term]}%')") if params[:term].present?

      queryy = arr.join(' and ')
      if arr.length > 0
        @total_articles = Article.where(queryy).count
        @articles = Article.where(queryy).order("created_at DESC").page(page).per(10)
      else
        @total_articles = Article.count
        @articles = Article.order("created_at DESC").page(page).per(10)
      end

      @articles = @articles.map do | article |
        article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
      end
    end

end
