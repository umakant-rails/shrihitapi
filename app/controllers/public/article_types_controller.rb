class Public::ArticleTypesController < ApplicationController

  def index
    page = params[:page].present? ? params[:page] : 1

    @total_article_types = ArticleType.count
    @article_types = ArticleType.includes(:articles).order("name ASC").page(page).per(10)

    article_types = @article_types.map do | at |
      at.attributes.merge({articles: at.articles})
    end
    render json: {
      article_types: @article_types,
      total_article_types: @total_article_types,
    }
  end
  
  def show
    page = params[:page].present? ? params[:page] : 1

    article_type = ArticleType.where(name: params[:id]).first rescue nil

    articles = article_type.articles.page(page).per(10) rescue nil
    total_articles = article_type.articles.count rescue nil

    articles =  articles && articles.map do | article |
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end

    render json: {
      article_type: article_type,
      articles: articles,
      total_articles: total_articles,
    }
  end

end
