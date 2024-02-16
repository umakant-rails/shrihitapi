class Admin::AuthorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @authors = current_user.authors.page(params[:page])
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
      scriptures: @scriptures,
      total_articles: total_articles,
      articles: articles_tmp
    }
  end

end
